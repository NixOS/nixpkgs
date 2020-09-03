{ lib
, buildPythonPackage
, fetchPypi
, pbr
, six
, wrapt

, doc8
, fixtures
}:

buildPythonPackage rec {
  pname = "debtcollector";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ab8ic9bk644i8134z044kpcf6pvawqf4rq4xgv1p11msbs82ybq";
  };

  patches = [ ./tox-pass-system-pythonpath.patch ];

  propagatedBuildInputs = [
    pbr
    six
    wrapt
  ];

  checkInputs = [
    doc8
    fixtures
  ];

  # Circular dependencies on stestr, see https://bugs.launchpad.net/oslo.config/+bug/1893978
  doCheck = false;

  meta = with lib; {
    description = "Python library to collect your technical debt";
    license = licenses.asl20;
    longDescription = ''
      A collection of Python deprecation patterns and strategies that help you
      collect your technical debt in a non-destructive manner. The goal of this
      library is to provide well documented developer facing deprecation
      patterns that start of with a basic set and can expand into a larger set
      of patterns as time goes on. The desired output of these patterns is to
      apply the warnings module to emit DeprecationWarning or
      PendingDeprecationWarning or similar derivative to developers using
      libraries (or potentially applications) about future deprecations.
    '';
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
