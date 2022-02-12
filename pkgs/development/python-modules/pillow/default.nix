{ lib, stdenv, buildPythonPackage, fetchPypi, isPyPy, isPy3k, fetchpatch
, defusedxml, olefile, freetype, libjpeg, zlib, libtiff, libwebp, tcl, lcms2, tk, libX11
, libxcb, openjpeg, libimagequant, pyroma, numpy, pytestCheckHook
}@args:

import ./generic.nix (rec {
  pname = "Pillow";
  version = "8.3.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1361y215ydmdh4il1vay5831aqivmpwgzjqrphqjdiq0ipnz7qyx";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-22815.patch";
      url = "https://github.com/python-pillow/Pillow/commit/1e092419b6806495c683043ab3feb6ce264f3b9c.patch";
      sha256 = "1mafa8ixh4a4nh98yjp7dhh68kk4sxbzjm468h9gjba0py8657rd";
    })
    (fetchpatch {
      name = "CVE-2022-22816.patch";
      url = "https://github.com/python-pillow/Pillow/commit/c48271ab354db49cdbd740bc45e13be4f0f7993c.patch";
      sha256 = "1jr25918lxqljswv1jc7m3nn370xrz0l7g39lbyh5ndjz1dmnpvv";
    })
    (fetchpatch {
      name = "CVE-2022-22817.patch";
      url = "https://github.com/python-pillow/Pillow/commit/8531b01d6cdf0b70f256f93092caa2a5d91afc11.patch";
      excludes = [ "docs/releasenotes/9.0.0.rst" ];
      sha256 = "13va7lmja9bkp1d8bnwpns9nh7p31kal89cvfky4r95lx0ckrnfv";
    })
    (fetchpatch {
      name = "CVE-2022-22817.part-2.patch";
      url = "https://github.com/python-pillow/Pillow/commit/c930be0758ac02cf15a2b8d5409d50d443550581.patch";
      sha256 = "123ihfpg86zxlyvb22d5khkrqwv7q3chi2q7kkjyk1k6r84nz4ad";
    })
    (fetchpatch {
      name = "CVE-2022-24303.part-1.patch";
      url = "https://github.com/python-pillow/Pillow/commit/427221ef5f19157001bf8b1ad7cfe0b905ca8c26.patch";
      sha256 = "0i7sys6argz320fzyny6fzps9kwvni6i0j3wa97j04k0vigdd5rp";
    })
    (fetchpatch {
      name = "CVE-2022-24303.part-2.patch";
      url = "https://github.com/python-pillow/Pillow/commit/ca0b58521881b95e47ea49d960d13d1c3dac823d.patch";
      sha256 = "13f61ab6a6nnzhig0jbsnlmkzvbslpaycrc2iiqmw91glxbw57bh";
    })
    (fetchpatch {
      name = "CVE-2022-24303.part-3.patch";
      url = "https://github.com/python-pillow/Pillow/commit/02affaa491df37117a7562e6ba6ac52c4c871195.patch";
      sha256 = "04n0l2k6ikhh15ix8f0dwxx2jk59r9y3z0ix6jz3vz1yq0as16c7";
    })
  ];

  meta = with lib; {
    homepage = "https://python-pillow.org/";
    description = "The friendly PIL fork (Python Imaging Library)";
    longDescription = ''
      The Python Imaging Library (PIL) adds image processing
      capabilities to your Python interpreter.  This library
      supports many file formats, and provides powerful image
      processing and graphics capabilities.
    '';
    license = licenses.hpnd;
    maintainers = with maintainers; [ goibhniu prikhi SuperSandro2000 ];
  };
} // args )
