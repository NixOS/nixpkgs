{ lib
, buildPythonPackage
, fetchurl
}:

buildPythonPackage rec {
  pname = "entry-points-txt";
  version = "0.1.0";
  format = "wheel";

  src = fetchurl {
    url = "https://github.com/jwodder/entry-points-txt/releases/download/v0.1.0/entry_points_txt-0.1.0-py3-none-any.whl";
    sha256 = "29773bed3d9d337766a394e19d6f7ab0be3ed7d6f3ebb753ff0f7f48f056aa8e";
  };

  meta = with lib; {
    homepage = "https://github.com/jwodder/entry-points-txt";
    description = "Read & write entry_points.txt files";
    license = with licenses; [ mit ];
    maintainers = with lib.maintainers; [ ayazhafiz ];
  };
}
