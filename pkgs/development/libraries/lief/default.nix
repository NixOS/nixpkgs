{ stdenv, fetchzip }:

fetchzip {
  url = https://github.com/lief-project/LIEF/releases/download/0.9.0/LIEF-0.9.0-Linux.tar.gz;
  sha256 = "1c47hwd00bp4mqd4p5b6xjfl89c3wwk9ccyc3a2gk658250g2la6";

  meta = with stdenv.lib; {
    description = "Library to Instrument Executable Formats";
    homepage = https://lief.quarkslab.com/;
    license = [ licenses.asl20 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.lassulus ];
  };
}
