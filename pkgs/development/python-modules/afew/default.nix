{ stdenv, buildPythonPackage, fetchFromGitHub
, isPy3k , setuptools_scm, notmuch, chardet, subprocess32 }:

buildPythonPackage rec {
  pname = "afew";
  version = "1.2.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "afewmail";
    repo = "afew";
    rev = "3405475276a2433e1238be330e538ebf2a976e5e";
    sha256 = "1h974avnfc6636az130yjqwm28z3aaqm49bjhpy3razx6zvyhzlf";
  };

  buildInputs = [ setuptools_scm ];
  SETUPTOOLS_SCM_PRETEND_VERSION = "${version}";

  propagatedBuildInputs = [
    notmuch
    chardet
  ] ++ stdenv.lib.optional (!isPy3k) subprocess32;

  postInstall = ''
    wrapProgram $out/bin/afew \
      --prefix LD_LIBRARY_PATH : ${notmuch}/lib
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/afewmail/afew;
    description = "An initial tagging script for notmuch mail";
    maintainers = with maintainers; [ garbas andir flokli ];
  };
}
