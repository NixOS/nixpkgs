{ stdenv
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, pythonOlder
, paver
, python
, isPyPy
, six
, pathlib
, python_magic
, isPy3k
, lib
}:

buildPythonPackage rec {
  version = "0.8.9";
  pname    = "eyeD3";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6bb626566f2949da409d7a871576271e2d6254dfb3d416b21713dabc4b6b00f";
  };

  # https://github.com/nicfit/eyeD3/pull/284
  postPatch = lib.optionalString (pythonAtLeast "3.4") ''
    sed -ie '/pathlib/d' requirements/requirements.yml
  '';

  buildInputs = [ paver ];

  # requires special test data:
  # https://github.com/nicfit/eyeD3/blob/103198e265e3279384f35304e8218be6717c2976/Makefile#L97
  doCheck = false;

  propagatedBuildInputs = [ six python_magic ] ++ lib.optional (pythonOlder "3.4") pathlib;

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
