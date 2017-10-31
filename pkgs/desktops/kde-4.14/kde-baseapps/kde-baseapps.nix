{ stdenv, kde, kdelibs, html-tidy, kactivities, libXt }:

kde {
  postPatch = ''
    substituteInPlace konq-plugins/validators/tidy_validator.cpp \
      --replace buffio.h tidybuffio.h
  '';

  buildInputs = [ kdelibs html-tidy kactivities libXt ];

  meta = {
    description = "Base KDE applications, including the Dolphin file manager and Konqueror web browser";
    license = stdenv.lib.licenses.gpl2;
  };
}
