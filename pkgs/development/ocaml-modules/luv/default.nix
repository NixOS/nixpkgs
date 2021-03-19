{ lib, buildDunePackage, fetchurl, ctypes }:

buildDunePackage rec {
  pname = "luv";
  version = "0.5.6";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/aantron/luv/releases/download/${version}/luv-${version}.tar.gz";
    sha256 = "119nv250fsadvrs94nwzk7qvlwr0kvcpkbwcmfkh13byg8nhkn1m";
  };

  postConfigure = ''
    for f in src/c/vendor/configure/{ltmain.sh,configure}; do
      substituteInPlace "$f" --replace /usr/bin/file file
    done
  '';

  nativeBuildInputs = [ file ];
  
  propagatedBuildInputs = [ ctypes result ];

  meta = with lib; {
    homepage = "https://github.com/aantron/luv";
    description = "Binding to libuv: cross-platform asynchronous I/O";
    license = licenses.lgpl21;
    maintainers = [ maintainers.locallycompact ];
  };
}
