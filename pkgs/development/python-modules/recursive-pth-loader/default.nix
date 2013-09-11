{ stdenv, python }:

stdenv.mkDerivation rec {
  name = "python-recursive-pth-loader-1.0";

  unpackPhase = "true";

  buildInputs = [ python ];

  patchPhase = "cat ${./sitecustomize.py} > sitecustomize.py";

  buildPhase = "${python}/bin/${python.executable} -m compileall .";

  installPhase =
    ''
      dst=$out/lib/${python.libPrefix}/site-packages
      mkdir -p $dst
      cp sitecustomize.* $dst/
    '';

  meta = {
      description = "Enable recursive processing of pth files anywhere in sys.path";
  };
}
