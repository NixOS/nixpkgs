{
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "characteristic";
  version = "14.3.0";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3taNTkJBFe1E5cg8KpAaC2FXqVkHnXWR2SEG/9Oto4A=";
  };

  nativeCheckInputs = [ pytest ];

  postPatch = ''
    substituteInPlace setup.cfg --replace "[pytest]" "[tool:pytest]"
  '';

  meta = {
    description = "Python attributes without boilerplate";
    homepage = "https://characteristic.readthedocs.org";
  };
}
