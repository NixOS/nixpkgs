{ stdenv, buildPythonPackage, fetchPypi, sphinx, setuptools-lint, xlib }:

buildPythonPackage rec {
  pname = "pynput";
  version = "1.6.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16h4wn7f54rw30jrya7rmqkx3f51pxn8cplid95v880md8yqdhb8";
  };

  nativeBuildInputs = [ sphinx ];

  propagatedBuildInputs = [ setuptools-lint xlib ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A library to control and monitor input devices";
    homepage = "https://github.com/moses-palmer/pynput";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ nickhu ];
  };
}

