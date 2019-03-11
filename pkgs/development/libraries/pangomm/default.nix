{ stdenv, fetchurl, pkgconfig, pango, glibmm, cairomm, gnome3
, ApplicationServices }:

stdenv.mkDerivation rec {
  pname = "pangomm";
  version= "2.42.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0mmzxp3wniaafkxr30sb22mq9x44xckb5d60h1bl99lkzxks0vfa";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ] ++ stdenv.lib.optional stdenv.isDarwin [
    ApplicationServices
  ];
  propagatedBuildInputs = [ pango glibmm cairomm ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "C++ interface to the Pango text rendering library";
    homepage    = https://www.pango.org/;
    license     = with licenses; [ lgpl2 lgpl21 ];
    maintainers = with maintainers; [ lovek323 raskin ];
    platforms   = platforms.unix;

    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK+ widget toolkit.
      Pango forms the core of text and font handling for GTK+-2.x.
    '';
  };
}
