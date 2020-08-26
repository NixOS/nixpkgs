{ lib, buildPythonPackage, fetchPypi
, dateutil, docopt, pyyaml
, pytest, testfixtures
}:

buildPythonPackage rec {
  version = "1.7.0";
  pname = "pykwalify";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cnfzkg1b01f825ikpw2fhjclf9c8akxjfrbd1vc22x1lg2kk2vy";
  };

  propagatedBuildInputs = [
    dateutil
    docopt
    pyyaml
  ];

  checkInputs = [
    pytest
    testfixtures
  ];

  checkPhase = ''
    pytest \
      -k 'not test_multi_file_support'
  '';

  meta = with lib; {
    homepage = "https://github.com/Grokzen/pykwalify";
    description = "YAML/JSON validation library";
    longDescription = ''
      This framework is a port with a lot of added functionality
      of the Java version of the framework kwalify that can be found at
      http://www.kuwata-lab.com/kwalify/

      The original source code can be found at
      http://sourceforge.net/projects/kwalify/files/kwalify-java/0.5.1/

      The source code of the latest release that has been used can be found at
      https://github.com/sunaku/kwalify.
      Please note that source code is not the original authors code
      but a fork/upload of the last release available in Ruby.

      The schema this library is based on and extended from:
      http://www.kuwata-lab.com/kwalify/ruby/users-guide.01.html#schema
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
