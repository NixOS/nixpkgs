{ buildPythonPackage
, fetchPypi
, lib
, recursivePthLoader
, pyaml
, identify
, nodeenv
, virtualenv
, aspy-yaml
, six
, cached-property
, importlib-resources
, importlib-metadata
, toml
, cfgv
, python36
}:

buildPythonPackage rec {
  pname = "pre_commit";
  version = "1.12.0";
  name = "${pname}-${version}";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "0q95s22vs0jcbr7k9i0qgq7s30pfcicjkad0bqblb1y5w65bshkm";
  };

  doCheck = false;
  propagatedBuildInputs = [ pyaml identify nodeenv virtualenv aspy-yaml six cached-property toml cfgv importlib-resources importlib-metadata];

  postInstall = ''
    export PYTHONPATH="$out/lib/${python36.libPrefix}/site-packages:$PYTHONPATH"
    for i in "$out/bin/"*
    do
      wrapProgram "$i" --set PYTHONPATH $PYTHONPATH
    done
  '';

  meta = {
    description = "A framework for managing and maintaining multi-language pre-commit hooks.";
    homepage = https://pre-commit.com/;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jfroche ];
  };
}
