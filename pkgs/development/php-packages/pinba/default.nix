{ buildPecl, lib, fetchFromGitHub }:

buildPecl {
  pname = "pinba";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "tony2001";
    repo = "pinba_extension";
    rev = "RELEASE_1_1_2";
    sha256 = "0wqcqq6sb51wiawa37hbd1h9dbvmyyndzdvz87xqji7lpr9vn8jy";
  };

  meta = with lib; {
    description = "PHP extension for Pinba";
    longDescription = ''
      Pinba is a MySQL storage engine that acts as a realtime monitoring and
      statistics server for PHP using MySQL as a read-only interface.
    '';
    license = licenses.lgpl2Plus;
    homepage = "http://pinba.org/";
    maintainers = teams.php.members;
  };
}
