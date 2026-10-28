{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
}:

buildPythonPackage {
  pname = "pypubsub";
  version = "4.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "schollii";
    repo = "pypubsub";
    rev = "v4.0.3";
    hash = "sha256-i+7IR5s7A+kBApQ9OLCL8scnuQ+mRDRn361+jgQnRwo=";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    cd tests/suite
    py.test
  '';

  meta = {
    homepage = "https://github.com/schollii/pypubsub";
    description = "Python 3 publish-subscribe library";
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
    license = lib.licenses.bsd2;
  };
}
