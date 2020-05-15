{ buildPythonPackage
, fetchFromGitHub
, imageio
, imagecorruptions
, numpy
, opencv3
, pytestCheckHook
, scikitimage
, scipy
, shapely
, six
, stdenv
}:

buildPythonPackage rec {
  pname = "imgaug";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "aleju";
    repo = "imgaug";
    rev = version;
    sha256 = "17hbxndxphk3bfnq35y805adrfa6gnm5x7grjxbwdw4kqmbbqzah";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "opencv-python-headless" ""
    substituteInPlace setup.py \
      --replace "opencv-python-headless" ""
    substituteInPlace pytest.ini \
      --replace "--xdoctest --xdoctest-global-exec=\"import imgaug as ia\nfrom imgaug import augmenters as iaa\"" ""
  '';

  propagatedBuildInputs = [
    imageio
    imagecorruptions
    numpy
    opencv3
    scikitimage
    scipy
    shapely
    six
  ];

  # checkPhase = ''
  #    pytest
  # '';

  pytestFlagsArray = [ 
    # imagecorruptions not currently in nixpkgs
    "--ignore=test/augmenters/test_imgcorruptlike.py"
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/aleju/imgaug";
    description = "Image augmentation for machine learning experiments";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai rakesh4g ];
    platforms = platforms.linux;
  };
}
