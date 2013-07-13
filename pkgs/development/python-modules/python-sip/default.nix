{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "sip-4.14.6";
  
  src = fetchurl {
    urls = [
      "http://www.riverbankcomputing.co.uk/static/Downloads/sip4/${name}.tar.gz"
      "http://pkgs.fedoraproject.org/repo/pkgs/sip/${name}.tar.gz/d6493b9f0a7911566545f694327314c4/${name}.tar.gz"
    ];
    sha256 = "1bwdd5xhrx8dx8rr86r043ddlbg7gd1vh0pm2nxw5l1yprwa7paa";
  };

  configurePhase = stdenv.lib.optionalString stdenv.isDarwin ''
    # prevent sip from complaining about python not being built as a framework
    sed -i -e 1564,1565d siputils.py
  '' + ''
    python ./configure.py -d $out/lib/${python.libPrefix}/site-packages \
      -b $out/bin -e $out/include
  '';
  
  buildInputs = [ python ];
  
  meta = with stdenv.lib; {
    description = "Creates C++ bindings for Python modules";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 sander urkud ];
    platforms   = platforms.all;
  };
}
