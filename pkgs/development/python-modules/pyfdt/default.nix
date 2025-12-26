{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pyfdt";
  version = "0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "pyfdt";
    hash = "sha256:1w7lp421pssfgv901103521qigwb12i6sk68lqjllfgz0lh1qq31";
  };

  doCheck = false; # tests do not compile, see https://github.com/superna9999/pyfdt/issues/21

  pythonImportsCheck = [ "pyfdt" ];

  meta = {
    homepage = "https://github.com/superna9999/pyfdt";
    description = "Flattened device tree parser";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ralismark ];
  };
}
