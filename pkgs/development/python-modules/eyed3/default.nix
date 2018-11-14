{ stdenv
, buildPythonPackage
, fetchurl
, paver
, python
, isPyPy
}:

buildPythonPackage rec {
  version = "0.7.8";
  pname    = "eyeD3";
  disabled = isPyPy;

  src = fetchurl {
    url = "http://eyed3.nicfit.net/releases/${pname}-${version}.tar.gz";
    sha256 = "1nv7nhfn1d0qm7rgkzksbccgqisng8klf97np0nwaqwd5dbmdf86";
  };

  buildInputs = [ paver ];

  postInstall = ''
    for prog in "$out/bin/"*; do
      wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH" \
                          --prefix PATH : ${python}/bin
    done
  '';

  meta = with stdenv.lib; {
    description = "A Python module and command line program for processing ID3 tags";
    homepage    = http://eyed3.nicfit.net/;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
    longDescription = ''
      eyeD3 is a Python module and command line program for processing ID3
      tags. Information about mp3 files (i.e bit rate, sample frequency, play
      time, etc.) is also provided. The formats supported are ID3 v1.0/v1.1
      and v2.3/v2.4.
    '';
  };

}
