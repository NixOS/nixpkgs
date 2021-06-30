lib: with lib; {
  homepage = "https://openjdk.java.net/";
  license = licenses.gpl2Only;
  description = "The open-source Java Development Kit";
  maintainers = with maintainers; [ edwtjo asbachb ];
  platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" "armv7l-linux" "armv6l-linux" ];
  mainProgram = "java";
}
