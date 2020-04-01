{ stdenv, lib, buildPythonPackage, fetchFromGitHub, augeas, cffi }:
buildPythonPackage rec {
    pname = "augeas";
    version = "1.1.0";

    src = fetchFromGitHub {
      owner = "hercules-team";
      repo = "python-augeas";
      rev = "v${version}";
      sha256 = "12q52ilcx059rn544x3712xq6myn99niz131l0fs3xx67456pajh";
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
