{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub, fetchpatch
, flask, flask_wtf, flask_testing, ldap
, mock, nose }:

buildPythonPackage rec {
  pname = "flask-ldap-login";
  version = "0.3.4";
  disabled = isPy3k;

  src = fetchFromGitHub {
    owner = "ContinuumIO";
    repo = "flask-ldap-login";
    rev = version;
    sha256 = "1l6zahqhwn5g9fmhlvjv80288b5h2fk5mssp7amdkw5ysk570wzp";
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
