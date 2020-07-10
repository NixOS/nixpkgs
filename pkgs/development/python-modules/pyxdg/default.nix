{ stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
}:

buildPythonPackage rec {
  pname = "pyxdg";
  version = "0.26";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fe2928d3f532ed32b39c32a482b54136fe766d19936afc96c8f00645f9da1a06";
  };

  # error: invalid command 'test'
  doCheck = false;

  patches = [ 
    # see: https://gitlab.freedesktop.org/xdg/pyxdg/-/merge_requests/5 
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/xdg/pyxdg/-/commit/78405aaa34463db2c6f33ca28ae2293dd3bb1e91.patch";
      sha256 = "17cjax546rkqv5kvwczjqjdd6vmlvcxjanz0296dlfq23j2wbx63";
    })
  ];

  meta = with stdenv.lib; {
    homepage = "http://freedesktop.org/wiki/Software/pyxdg";
    description = "Contains implementations of freedesktop.org standards";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ domenkozar ];
  };

}
