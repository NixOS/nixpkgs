{ lib
, buildPythonPackage
, fetchFromGitHub
, prompt_toolkit1
, regex
, pygments
, pytest-html
, pytest-xdist
, pytestCheckHook
, ptyprocess
}:

buildPythonPackage rec {
  pname = "PyInquirer";
  version = "1.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "CITGuru";
    repo = pname;
    rev = version;
    sha256 = "1qv2bfcmnnblzysksgp6qd9ipm6hrk9vjm72ava869qhcfn11zni";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "prompt_toolkit==1.0.14" "prompt_toolkit<2.0"
  '';

  propagatedBuildInputs = [
    prompt_toolkit1
    pygments
    regex
  ];

  # The tests have been in a broken state for a while, with gems like this:
  #   AssertionError: assert '? Do you like bacon?  No\n' == '? Do you lik...pizza?  (y/N)'
  doCheck = false;

  checkInputs = [
    pytest-html
    pytest-xdist
    pytestCheckHook
    ptyprocess
  ];

  pythonImportsCheck = [
    "PyInquirer"
  ];

  meta = with lib; {
    description = "A Python module for common interactive command line user interfaces";
    homepage = "https://github.com/CITGuru/PyInquirer";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
