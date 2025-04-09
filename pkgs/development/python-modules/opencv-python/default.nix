{
  mkPythonMetaPackage,
  opencv4,
}:

mkPythonMetaPackage {
  pname = "opencv-python";
  inherit (opencv4) version;
  dependencies = [ opencv4 ];
  optional-dependencies = opencv4.optional-dependencies or { };
  meta = {
    inherit (opencv4.meta) description homepage;
    badPlatforms = [
      # ImportError: dlopen(/nix/store/rlkm45snzxvqfvpxwk7bfi5x1df89i63-opencv-4.11.0/lib/python3.12/site-packages/cv2/python-3.12/cv2.cpython-312-darwin.so, 0x0002): Symbol not found: __ZTINSt3__117bad_function_callE
      #   Referenced from: <FFAD12B0-6FC6-3AD9-A5E3-75865D785E79> /nix/store/rlkm45snzxvqfvpxwk7bfi5x1df89i63-opencv-4.11.0/lib/libopencv_imgcodecs.4.11.0.dylib
      #   Expected in:     <F0AC1571-049A-3F10-BA96-5C6AD56E68C0> /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
      "x86_64-darwin"
    ];
  };
}
