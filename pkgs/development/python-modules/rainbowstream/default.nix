{ stdenv
, buildPythonPackage
, fetchPypi
, python
, pkgs
, pillow
, twitter
, pyfiglet
, requests
, arrow
, dateutil
, pysocks
, pocket
}:

buildPythonPackage rec {
  pname = "rainbowstream";
  version = "1.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "527d39778c55d88300fe2017913341bfa1b1f0ffdc1fe5eab57a82bf4cd2edb3";
  };

  patches = [ ./image.patch ];

  postPatch = ''
    clib=$out/${python.sitePackages}/rainbowstream/image.so
    substituteInPlace rainbowstream/c_image.py \
      --replace @CLIB@ $clib
    sed -i 's/requests.*"/requests"/' setup.py
  '';

  LC_ALL="en_US.UTF-8";

  postInstall = ''
    mkdir -p $out/lib
    cc -fPIC -shared -o $clib rainbowstream/image.c
    for prog in "$out/bin/"*; do
      wrapProgram "$prog" \
        --prefix PYTHONPATH : "$PYTHONPATH"
    done
  '';

  buildInputs =  [ pkgs.libjpeg pkgs.freetype pkgs.zlib pkgs.glibcLocales pillow twitter pyfiglet requests arrow dateutil pysocks pocket ];

  meta = with stdenv.lib; {
    description = "Streaming command-line twitter client";
    homepage    = "http://www.rainbowstream.org/";
    license     = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice ];
  };

}
