{ lib
, fetchFromGitHub
, fetchurl
, buildPythonPackage
, pkgsStatic
, openssl
, invoke
, tls-parser
, cacert
, pytestCheckHook
, pythonOlder
}:

let
  zlibStatic = (pkgsStatic.zlib.override {
    splitStaticOutput = false;
  }).overrideAttrs (oldAttrs: {
    NIX_CFLAGS_COMPILE = "${oldAttrs.NIX_CFLAGS_COMPILE} -fPIC";
  });
  nasslOpensslArgs = {
    static = true;
    enableSSL2 = true;
  };
  nasslOpensslFlagsCommon = [
    "zlib"
    "no-zlib-dynamic"
    "no-shared"
    "--with-zlib-lib=${zlibStatic.out}/lib"
    "--with-zlib-include=${zlibStatic.out.dev}/include"
    "enable-rc5"
    "enable-md2"
    "enable-gost"
    "enable-cast"
    "enable-idea"
    "enable-ripemd"
    "enable-mdc2"
    "-fPIC"
  ];
  opensslStatic = (openssl.override nasslOpensslArgs).overrideAttrs (
    oldAttrs: rec {
      name = "openssl-${version}";
      version = "1.1.1h";
      src = fetchurl {
        url = "https://www.openssl.org/source/${name}.tar.gz";
        sha256 = "1ncmcnh5bmxkwrvm0m1q4kdcjjfpwvlyjspjhibkxc6p9dvsi72w";
      };
      configureFlags = oldAttrs.configureFlags ++ nasslOpensslFlagsCommon ++ [
        "enable-weak-ssl-ciphers"
        "enable-tls1_3"
        "no-async"
      ];
      buildInputs = oldAttrs.buildInputs ++ [ zlibStatic cacert ];
    }
  );
  opensslLegacyStatic = (openssl.override nasslOpensslArgs).overrideAttrs (
    oldAttrs: rec {
      name = "openssl-${version}";
      version = "1.0.2e";
      src = fetchurl {
        url = "https://www.openssl.org/source/${name}.tar.gz";
        sha256 = "1zqb1rff1wikc62a7vj5qxd1k191m8qif5d05mwdxz2wnzywlg72";
      };
      configureFlags = oldAttrs.configureFlags ++ nasslOpensslFlagsCommon;
      patches = [ ];
      buildInputs = oldAttrs.buildInputs ++ [ zlibStatic ];
      # openssl_1_0_2 needs `withDocs = false`
      outputs = lib.remove "doc" oldAttrs.outputs;
    }
  );
in
buildPythonPackage rec {
  pname = "nassl";
  version = "4.0.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nabla-c0d3";
    repo = pname;
    rev = version;
    hash = "sha256-6lk2YfI9km10YbJAn38fvo9qa4iXcByL+udCsDe+kvU=";
  };

  postPatch = let
    legacyOpenSSLVersion = lib.replaceStrings ["."] ["_"] opensslLegacyStatic.version;
    modernOpenSSLVersion = lib.replaceStrings ["."] ["_"] opensslStatic.version;
    zlibVersion = zlibStatic.version;
  in ''
    mkdir -p deps/openssl-OpenSSL_${legacyOpenSSLVersion}/
    cp ${opensslLegacyStatic.out}/lib/libssl.a \
      ${opensslLegacyStatic.out}/lib/libcrypto.a \
      deps/openssl-OpenSSL_${legacyOpenSSLVersion}/
    ln -s ${opensslLegacyStatic.out.dev}/include deps/openssl-OpenSSL_${legacyOpenSSLVersion}/include
    ln -s ${opensslLegacyStatic.bin}/bin deps/openssl-OpenSSL_${legacyOpenSSLVersion}/apps

    mkdir -p deps/openssl-OpenSSL_${modernOpenSSLVersion}/
    cp ${opensslStatic.out}/lib/libssl.a \
      ${opensslStatic.out}/lib/libcrypto.a \
      deps/openssl-OpenSSL_${modernOpenSSLVersion}/
    ln -s ${opensslStatic.out.dev}/include deps/openssl-OpenSSL_${modernOpenSSLVersion}/include
    ln -s ${opensslStatic.bin}/bin deps/openssl-OpenSSL_${modernOpenSSLVersion}/apps

    mkdir -p deps/zlib-${zlibVersion}/
    cp ${zlibStatic.out}/lib/libz.a deps/zlib-${zlibVersion}/
  '';

  propagatedBuildInputs = [ tls-parser ];

  nativeBuildInputs = [ invoke ];

  buildPhase = ''
    invoke build.nassl
    invoke package.wheel
  '';

  doCheck = true;

  pythonImportsCheck = [ "nassl" ];

  checkInputs = [ pytestCheckHook ];

  disabledTests = [
    "Online"
  ];

  meta = with lib; {
    homepage = "https://github.com/nabla-c0d3/nassl";
    description = "Low-level OpenSSL wrapper for Python 3.7+";
    platforms = with platforms; linux ++ darwin;
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ veehaitch ];
  };
}
