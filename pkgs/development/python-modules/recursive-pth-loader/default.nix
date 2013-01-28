{ stdenv, python }:

stdenv.mkDerivation rec {
  name = "python-recursive-pth-loader-1.0";

  unpackPhase = "true";

  buildInputs = [ python ];

  installPhase =
    ''
      dst=$out/lib/${python.libPrefix}/site-packages
      mkdir -p $dst
      cat ${./sitecustomize.py} >> $dst/sitecustomize.py
    '';

  meta = {
      description = "Enable recursive processing of pth files anywhere in sys.path";
  };
}
