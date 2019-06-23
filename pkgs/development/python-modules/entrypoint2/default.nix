{ stdenv, buildPythonPackage, fetchPypi, decorator, EasyProcess, nose, pathpy }:

buildPythonPackage rec {
  pname = "entrypoint2";
  version = "0.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vpqqc4nff6658nyvzz3hr0mvdwr97x1wbvndjn78n54y91s4wms";
  };

  postPatch = ''
    substituteInPlace requirements.txt --replace "argparse" ""
    substituteInPlace ./entrypoint2/__init__.py \
      --replace "except UsageError, e:" "except UsageError as e:"
  '';

  propagatedBuildInputs = [ decorator ];
  checkInputs = [ EasyProcess nose pathpy ];

  checkPhase = ''
    runHook preCheck
    nosetests
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    description = "Easy to use command-line interface for python modules, fork of entrypoint";
    homepage = https://github.com/ponty/entrypoint2;
    license = licenses.bsd2;
    maintainers = with maintainers; [ gerschtli ];
  };
}
