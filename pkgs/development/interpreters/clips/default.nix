{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "6.30";
  name = "clips-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/clipsrules/CLIPS/6.30/clips_core_source_630.tar.Z";
    sha256 = "1r0m59l3mk9cwzq3nmyr5qxrlkzp3njls4hfv8ml85dmqh7n3ysy";
  };
  buildPhase = ''
    make -C core -f ../makefiles/makefile.gcc
  '';
  installPhase = ''
    install -D -t $out/bin core/clips
  '';
  meta = with stdenv.lib; {
    description = "A Tool for Building Expert Systems";
    homepage = "http://www.clipsrules.net/";
    longDescription = ''
      Developed at NASA's Johnson Space Center from 1985 to 1996,
      CLIPS is a rule-based programming language useful for creating
      expert systems and other programs where a heuristic solution is
      easier to implement and maintain than an algorithmic solution.
    '';
    license = licenses.publicDomain;
    maintainers = [maintainers.league];
    platforms = platforms.linux;
  };
}
