{ stdenv, buildPythonPackage, fetchPypi, fetchpatch
, flask, flask_wtf, flask_testing, ldap
, mock, nose }:

buildPythonPackage rec {
  pname = "flask-ldap-login";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "085rik7q8xrp5g95346p6jcp9m2yr8kamwb2kbiw4q0b0fpnnlgq";
  };

  patches = [
    # Fix flask_wtf>=0.9.0 incompatibility. See https://github.com/ContinuumIO/flask-ldap-login/issues/41
    (fetchpatch {
      url = https://github.com/ContinuumIO/flask-ldap-login/commit/ed08c03c818dc63b97b01e2e7c56862eaa6daa43.patch;
      sha256 = "19pkhbldk8jq6m10kdylvjf1c8m84fvvj04v5qda4cjyks15aq48";
    })
  ];

  checkInputs = [ nose mock flask_testing ];
  propagatedBuildInputs = [ flask flask_wtf ldap ];

  checkPhase = "nosetests -d";

  meta = with stdenv.lib; {
    homepage = https://github.com/ContinuumIO/flask-ldap-login;
    description = "User session management for Flask";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ mic92 ];
  };
}
