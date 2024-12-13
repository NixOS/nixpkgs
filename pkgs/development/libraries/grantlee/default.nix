{
  stdenv,
  lib,
  fetchFromGitHub,
  qtbase,
  cmake,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "grantlee";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "steveire";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-enP7b6A7Ndew2LJH569fN3IgPu2/KL5rCmU/jmKb9sY=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];
  buildInputs = [ qtbase ];

  meta = {
    description = "Libraries for text templating with Qt";
    longDescription = ''
      Grantlee is a set of Free Software libraries written using the Qt framework. Currently two libraries are shipped with Grantlee: Grantlee Templates and Grantlee TextDocument.
      The goal of Grantlee Templates is to make it easier for application developers to separate the structure of documents from the data they contain, opening the door for theming and advanced generation of other text such as code.
      The syntax uses the syntax of the Django template system, and the core design of Django is reused in Grantlee.
    '';

    homepage = "https://github.com/steveire/grantlee";
    license = lib.licenses.lgpl21Plus;
  };
}
