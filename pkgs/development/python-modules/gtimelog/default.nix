{ stdenv
, buildPythonPackage
, fetchurl
, pkgs
, python
, pygobject3
}:

buildPythonPackage rec {
  pname = "gtimelog";
  version = "0.9.1";

  src = pkgs.fetchurl {
    url = "https://github.com/gtimelog/gtimelog/archive/${version}.tar.gz";
    sha256 = "0qk8fv8cszzqpdi3wl9vvkym1jil502ycn6sic4jrxckw5s9jsfj";
  };

  buildInputs = [ pkgs.glibcLocales ];

  LC_ALL="en_US.UTF-8";

  # TODO: AppIndicator
  propagatedBuildInputs = [ pkgs.gobject-introspection pygobject3 pkgs.makeWrapper pkgs.gtk3 ];

  checkPhase = ''
    substituteInPlace runtests --replace "/usr/bin/env python" "${python}/bin/${python.executable}"
    ./runtests
  '';

  preFixup = ''
      wrapProgram $out/bin/gtimelog \
        --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
        --prefix LD_LIBRARY_PATH ":" "${pkgs.gtk3.out}/lib" \
  '';

  meta = with stdenv.lib; {
    description = "A small Gtk+ app for keeping track of your time. It's main goal is to be as unintrusive as possible";
    homepage = https://mg.pov.lt/gtimelog/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ocharles ];
    platforms = platforms.unix;
  };

}
