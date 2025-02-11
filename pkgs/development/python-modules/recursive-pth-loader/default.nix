{ stdenv, python }:

stdenv.mkDerivation {
  pname = "python-recursive-pth-loader";
  version = "1.0";

  dontUnpack = true;

  buildInputs = [ python ];

  patchPhase = "cat ${./sitecustomize.py} > sitecustomize.py";

  buildPhase = "${python.pythonOnBuildForHost}/bin/${python.pythonOnBuildForHost.executable} -m compileall .";

  installPhase = ''
    dst=$out/${python.sitePackages}
    mkdir -p $dst
    cp sitecustomize.* $dst/
  '';

  meta = {
    description = "Enable recursive processing of pth files anywhere in sys.path";
  };
}
