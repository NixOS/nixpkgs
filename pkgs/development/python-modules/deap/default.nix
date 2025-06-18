{
  lib,
  buildPythonPackage,
  fetchPypi,
  matplotlib,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "deap";
  version = "1.4.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1nm+M3Pbi6kStGZCYMopx6yhA3L/WpaCMQR7Se/CKsU=";
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
  ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Novel evolutionary computation framework for rapid prototyping and testing of ideas";
    homepage = "https://github.com/DEAP/deap";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [
      getpsyched
      psyanticy
    ];
  };
}
