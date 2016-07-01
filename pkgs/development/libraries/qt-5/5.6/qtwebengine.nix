{ qtSubmodule, qtquickcontrols, qtlocation, qtwebchannel }:

qtSubmodule {
  name = "qtwebengine";
  qtInputs = [ qtquickcontrols qtlocation qtwebchannel ];
}
