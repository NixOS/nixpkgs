{ buildPythonPackage
, fetchFromGitHub
, pytest
, stdenv
}:

buildPythonPackage rec {
  pname = "pytest-helpers-namespace";
  version = "2019.1.8";

  src = fetchFromGitHub {
    owner = "saltstack";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "0z9f25d2wpf3lnqzmmnrlvl5b1f7kqwjjf4nzs9x2bpf91s5zny1";
  };

  buildInputs = [ pytest ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  # The tests fail with newest pytest. They passed with pytest_3, which no longer exists
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/saltstack/pytest-helpers-namespace";
    description = "PyTest Helpers Namespace";
    license = licenses.asl20;
    maintainers = [ maintainers.kiwi ];
  };
}
