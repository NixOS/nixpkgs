{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lima";
  version = "0.5";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qqj0053r77ppkcyyk2fhpaxjzsl1h98nf9clpny6cs66sdl241v";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Lightweight Marshalling of Python 3 Objects";
    homepage = "https://github.com/b6d/lima";
    license = licenses.mit;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
