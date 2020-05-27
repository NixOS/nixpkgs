{ stdenv, buildDunePackage, fetchFromGitHub, camlidl, fuse }:

buildDunePackage {
  pname = "ocamlfuse";
  version = "2.7.1_cvs6_e35e76b";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "ocamlfuse";
    rev = "e35e76bee3b06806256b5bfca108b7697267cd5c";
    sha256 = "1v9g0wh7rnjkrjrnw50145g6ry38plyjs8fq8w0nlzwizhf3qhff";
  };

  propagatedBuildInputs = [ camlidl fuse ];

  meta = {
    homepage = "https://sourceforge.net/projects/ocamlfuse";
    description = "OCaml bindings for FUSE";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
  };
}
