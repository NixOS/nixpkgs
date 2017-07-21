{ stdenv, buildPythonPackage, fetchFromGitHub
, isPy3k , dbacl, notmuch, chardet, subprocess32 }:

buildPythonPackage rec {
  pname = "afew";
  version = "git-2017-02-08";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "afewmail";
    repo = "afew";
    rev = "889a3b966835c4d16aa1f24bb89f12945b9b2a67";
    sha256 = "01gwrx1m3ka13ps3vj04a3y8llli2j2vkd3gcggcvxdphhpysckm";
  };

  buildInputs = [ dbacl ];

  propagatedBuildInputs = [
    notmuch
    chardet
  ] ++ stdenv.lib.optional (!isPy3k) subprocess32;

  doCheck = false;

  preConfigure = ''
    substituteInPlace afew/DBACL.py --replace "'dbacl'" "'${dbacl}/bin/dbacl'"
  '';

  postInstall = ''
    wrapProgram $out/bin/afew \
      --prefix LD_LIBRARY_PATH : ${notmuch}/lib
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/teythoon/afew;
    description = "An initial tagging script for notmuch mail";
    maintainers = with maintainers; [ garbas ];
  };
}
