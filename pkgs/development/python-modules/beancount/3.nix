{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  click,
  fetchPypi,
  isPy3k,
  meson,
  meson-python,
  pytestCheckHook,
  python-dateutil,
  regex,
}:

buildPythonPackage rec {
  version = "3.0.0";
  pname = "beancount";
  pyproject = true;

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-z2aGhpx+o+78CU7hPthmv196K7DGHk1PXfPjX4Rs/98=";
  };

  # Tests require files not included in the PyPI archive.
  # Also there is an import error after migration to meson build.
  doCheck = false;

  build-system = [
    meson
    meson-python
  ];

  depedencies = [
    click
    python-dateutil
    regex
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    click
    python-dateutil
    regex
  ];

  pythonImportsCheck = [ "beancount" ];

  meta = with lib; {
    homepage = "https://github.com/beancount/beancount";
    description = "Double-entry bookkeeping computer language";
    longDescription = ''
      A double-entry bookkeeping computer language that lets you define
      financial transaction records in a text file, read them in memory,
      generate a variety of reports from them, and provides a web interface.
    '';
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ bhipple ];
  };
}
