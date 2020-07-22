{ lib
, fetchFromGitHub
, fetchurl
, buildPythonPackage
, pkgsStatic
, openssl
, invoke
, pytest
, tls-parser
, cacert
}:

let
  zlibStatic = pkgsStatic.zlib;
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
      version = "1.1.1";
      src = fetchurl {
        url = "https://www.openssl.org/source/${name}.tar.gz";
        sha256 = "0gbab2fjgms1kx5xjvqx8bxhr98k4r8l2fa8vw7kvh491xd8fdi8";
      };
      configureFlags = oldAttrs.configureFlags ++ nasslOpensslFlagsCommon ++ [
        "enable-weak-ssl-ciphers"
        "enable-tls1_3"
        "no-async"
      ];
      patches = [ ./nix-ssl-cert-file.patch ];
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
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "nabla-c0d3";
    repo = pname;
    rev = version;
    sha256 = "1dhgkpldadq9hg5isb6mrab7z80sy5bvzad2fb54pihnknfwhp8z";
  };

  postPatch = ''
    mkdir -p deps/openssl-OpenSSL_1_0_2e/
    cp ${opensslLegacyStatic.out}/lib/libssl.a \
      ${opensslLegacyStatic.out}/lib/libcrypto.a \
      deps/openssl-OpenSSL_1_0_2e/
    ln -s ${opensslLegacyStatic.out.dev}/include deps/openssl-OpenSSL_1_0_2e/include 
    ln -s ${opensslLegacyStatic.bin}/bin deps/openssl-OpenSSL_1_0_2e/apps

    mkdir -p deps/openssl-OpenSSL_1_1_1/
    cp ${opensslStatic.out}/lib/libssl.a \
      ${opensslStatic.out}/lib/libcrypto.a \
      deps/openssl-OpenSSL_1_1_1/
    ln -s ${opensslStatic.out.dev}/include deps/openssl-OpenSSL_1_1_1/include 
    ln -s ${opensslStatic.bin}/bin deps/openssl-OpenSSL_1_1_1/apps

    mkdir -p deps/zlib-1.2.11/
    cp ${zlibStatic.out}/lib/libz.a deps/zlib-1.2.11/
  '';

  propagatedBuildInputs = [ tls-parser ];

  nativeBuildInputs = [ invoke ];

  buildPhase = ''
    invoke build.nassl
    invoke package.wheel
  '';

  checkInputs = [ pytest ];

  checkPhase = ''
    # Skip online tests
    pytest -k 'not Online'
  '';

  meta = with lib; {
    homepage = "https://github.com/nabla-c0d3/nassl";
    description = "Low-level OpenSSL wrapper for Python 3.7+";
    platforms = with platforms; linux ++ darwin;
    license = licenses.agpl3;
    maintainers = with maintainers; [ veehaitch ];
  };
}
