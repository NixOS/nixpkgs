{stdenv, fetchgit, unzip} :

stdenv.mkDerivation {
  name = "junit-4.8.2";
  builder = ./builder.sh;

  src = fetchgit {
    url = https://github.com/junit-team/junit.git;
    rev = "refs/tags/r4.8.2";
    sha256 = "1w73l3x97kg8zmrp44xgvp3gr6sih0crm0dhhky6jiq915ba1dlh";
  };

  inherit unzip;

  meta = {
    homepage = http://www.junit.org/;
  };
}
