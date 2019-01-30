{ stdenv
, buildPythonPackage
, fetchurl
, six
, wcwidth
}:

buildPythonPackage rec {
  pname = "prompt-toolkit";
  version = "2.0.8";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/0d/f7/571edf48b2e11678fa21245369678815a965bac1d96e09fa60fe365ff79d/prompt_toolkit-2.0.8.tar.gz";
    sha256 = "c6655a12e9b08edb8cf5aeab4815fd1e1bdea4ad73d3bbf269cf2e0c4eb75d5e";
  };

  doCheck = false;

  propagatedBuildInputs = [
    six
    wcwidth
  ];
  meta = with stdenv.lib; {
    homepage = "https://github.com/jonathanslenders/python-prompt-toolkit";
    license = "BSD-3-Clause";
    description = "Library for building powerful interactive command lines in Python";
    maintainers = with stdenv.lib.maintainers; [ bbarker ];
  };
}