{ lib
, buildPythonPackage
, fetchPypi
, babel
, humanize
, python-dateutil
, tzlocal
}:

buildPythonPackage rec {
  pname = "Delorean";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d31ay7yq2w7xz7m3ssk5phjbm64b2k8hmgcif22719k29p7hrzy";
  };

  propagatedBuildInputs = [ babel humanize python-dateutil tzlocal ];

  pythonImportsCheck = [ "delorean" ];

  # test data not included
  doCheck = false;

  meta = with lib; {
    description = "Delorean: Time Travel Made Easy";
    homepage = "https://github.com/myusuf3/delorean";
    license = licenses.mit;
    maintainers = with maintainers; [ globin ];
  };
}
