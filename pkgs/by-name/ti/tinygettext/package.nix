{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  tinycmmc,
  libiconv,
}:

stdenv.mkDerivation {
  pname = "tinygettext";
  version = "0.1.0-unstable-2025-05-07";

  src = fetchFromGitHub {
    owner = "tinygettext";
    repo = "tinygettext";
    rev = "ef4164639004d7de5bf8ab28ed0e85ea521b7c5e";
    sha256 = "sha256-if+uiVzDA3J+0HM6bVcXvm4lk82TmQmFHG4MtaxIFCk=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ tinycmmc ];
  propagatedBuildInputs = [ libiconv ];

  meta = {
    description = "A simple gettext replacement that works directly on .po files";
    maintainers = [ lib.maintainers.SchweGELBin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.zlib;
  };
}
