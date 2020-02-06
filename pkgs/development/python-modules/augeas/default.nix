{ stdenv, lib, buildPythonPackage, fetchFromGitHub, augeas, cffi }:
buildPythonPackage rec {
    pname = "augeas";
    version = "1.0.3";

    src = fetchFromGitHub {
      owner = "hercules-team";
      repo = "python-augeas";
      rev = "v${version}";
      sha256 = "1fb904ym8g8hkd82zlibzk6wrldnfd5v5d0rkynsy1zlhcylq4f6";
    };

    # TODO: not very nice!
    postPatch =
      let libname = if stdenv.isDarwin then "libaugeas.dylib" else "libaugeas.so";
      in
      ''
        substituteInPlace augeas/ffi.py \
          --replace 'ffi.dlopen("augeas")' \
                    'ffi.dlopen("${lib.makeLibraryPath [augeas]}/${libname}")'
      '';

    propagatedBuildInputs = [ cffi augeas ];

    doCheck = false;

    meta = with lib; {
      description = "Pure python bindings for augeas";
      homepage = https://github.com/hercules-team/python-augeas;
      license = licenses.lgpl2Plus;
      platforms = platforms.unix;
    };
}
