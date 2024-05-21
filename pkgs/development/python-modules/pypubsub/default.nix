{ lib, buildPythonPackage, fetchFromGitHub, isPy27, pytest }:

buildPythonPackage rec {
  pname = "pypubsub";
  version = "4.0.3";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "schollii";
    repo = "pypubsub";
    rev = "v4.0.3";
    sha256 = "02j74w28wzmdvxkk8i561ywjgizjifq3hgcl080yj0rvkd3wivlb";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    cd tests/suite
    py.test
  '';

  meta = with lib; {
    homepage = "https://github.com/schollii/pypubsub";
    description = "Python 3 publish-subcribe library";
    longDescription = ''
     Provides a publish-subscribe API to facilitate event-based or
     message-based  architecture in a single-process application. It is pure
     Python  and works on Python 3.3+. It is centered on the notion of a topic;
     senders publish messages of a given topic, and listeners subscribe to
     messages of a given topic, all inside the same process. The package also
     supports a variety of advanced features that facilitate debugging and
     maintaining topics and messages in larger desktop- or server-based
     applications.
    '';
    license = licenses.bsd2;
    maintainers = with maintainers; [ tfmoraes ];
  };
}
