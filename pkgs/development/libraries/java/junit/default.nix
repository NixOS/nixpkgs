{ stdenv, antBuild, fetchgit, perl }:

let
  version = "4.11";
in antBuild {
  name = "junit-${version}";

  # I think this is only used to generate the docs, and will likely disappear
  # with the next release of junit since its build system completely changes.
  buildInputs = [perl];

  src = fetchgit {
    url = "https://github.com/junit-team/junit.git";
    sha256 = "019azv0cfy2zs45c7g3r952gvjmikkq76p2ydr4q5252r0pzy9dr";
    rev = "c2e4d911fadfbd64444fb285342a8f1b72336169";
  };

  antProperties = [
    { name = "version"; value = version; }
  ];

  meta = {
    homepage = http://www.junit.org/;
    description = "A framework for repeatable tests in Java";
    license = stdenv.lib.licenses.epl10;
  };
}
