{ stdenv, lib, buildPythonPackage, fetchFromGitHub, augeas, cffi }:
buildPythonPackage rec {
    name = "augeas-${version}";
    version = "1.0.2";

    src = fetchFromGitHub {
      owner = "hercules-team";
      repo = "python-augeas";
      rev = "v${version}";
      sha256 = "1xk51m58ym3qpf0z5y98kzxb5jw7s92rca0v1yflj422977najxh";
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
