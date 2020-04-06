{fetchurl}:

{
  "10".google_apis."armeabi-v7a" = {
    name = "system-image-10-google_apis-armeabi-v7a";
    path = "system-images/android-10/google_apis/armeabi-v7a";
    revision = "10-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-10_r06.zip;
      sha1 = "970abf3a2a9937a43576afd9bb56e4a8191947f8";
    };
  };
  "10".google_apis."x86" = {
    name = "system-image-10-google_apis-x86";
    path = "system-images/android-10/google_apis/x86";
    revision = "10-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-10_r06.zip;
      sha1 = "070a9552e3d358d8e72e8b2042e539e2b7a1b035";
    };
  };
  "15".google_apis."x86" = {
    name = "system-image-15-google_apis-x86";
    path = "system-images/android-15/google_apis/x86";
    revision = "15-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-15_r06.zip;
      sha1 = "a7deb32c12396b6c4fd60ad14a62e19f8bdcae20";
    };
  };
  "15".google_apis."armeabi-v7a" = {
    name = "system-image-15-google_apis-armeabi-v7a";
    path = "system-images/android-15/google_apis/armeabi-v7a";
    revision = "15-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-15_r06.zip;
      sha1 = "6deb76cf34760a6037cb18d89772c9e986d07497";
    };
  };
  "16".google_apis."armeabi-v7a" = {
    name = "system-image-16-google_apis-armeabi-v7a";
    path = "system-images/android-16/google_apis/armeabi-v7a";
    revision = "16-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-16_r06.zip;
      sha1 = "5a5ff097680c6dae473c8719296ce6d7b70edb2d";
    };
  };
  "16".google_apis."x86" = {
    name = "system-image-16-google_apis-x86";
    path = "system-images/android-16/google_apis/x86";
    revision = "16-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-16_r06.zip;
      sha1 = "b57adef2f43dd176b8c02c980c16a796021b2071";
    };
  };
  "17".google_apis."armeabi-v7a" = {
    name = "system-image-17-google_apis-armeabi-v7a";
    path = "system-images/android-17/google_apis/armeabi-v7a";
    revision = "17-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-17_r06.zip;
      sha1 = "a59f26cb5707da97e869a27d87b83477204ac594";
    };
  };
  "17".google_apis."x86" = {
    name = "system-image-17-google_apis-x86";
    path = "system-images/android-17/google_apis/x86";
    revision = "17-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-17_r06.zip;
      sha1 = "7864c34faf0402b8923d8c6e609a5339f74cc8d6";
    };
  };
  "18".google_apis."armeabi-v7a" = {
    name = "system-image-18-google_apis-armeabi-v7a";
    path = "system-images/android-18/google_apis/armeabi-v7a";
    revision = "18-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-18_r06.zip;
      sha1 = "7faaccabbcc5f08e410436d3f63eea42521ea974";
    };
  };
  "18".google_apis."x86" = {
    name = "system-image-18-google_apis-x86";
    path = "system-images/android-18/google_apis/x86";
    revision = "18-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-18_r06.zip;
      sha1 = "dd674d719cad61602702be4b3d98edccfbfea53e";
    };
  };
  "19".google_apis."x86" = {
    name = "system-image-19-google_apis-x86";
    path = "system-images/android-19/google_apis/x86";
    revision = "19-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-19_r38.zip;
      sha1 = "928e4ec82876c61ef53451425d10ccb840cdd0f2";
    };
  };
  "19".google_apis."armeabi-v7a" = {
    name = "system-image-19-google_apis-armeabi-v7a";
    path = "system-images/android-19/google_apis/armeabi-v7a";
    revision = "19-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-19_r38.zip;
      sha1 = "434edd2ddc39d1ca083a5fa9721c0db8ab804737";
    };
  };
  "21".google_apis."x86" = {
    name = "system-image-21-google_apis-x86";
    path = "system-images/android-21/google_apis/x86";
    revision = "21-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-21_r30.zip;
      sha1 = "37548caae9e2897fb1d2b15f7fcf624c714cb610";
    };
  };
  "21".google_apis."x86_64" = {
    name = "system-image-21-google_apis-x86_64";
    path = "system-images/android-21/google_apis/x86_64";
    revision = "21-google_apis-x86_64";
    displayName = "Google APIs Intel x86 Atom_64 System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86_64-21_r30.zip;
      sha1 = "82d34fdaae2916bd4d48a4f144db51e4e5719aa4";
    };
  };
  "21".google_apis."armeabi-v7a" = {
    name = "system-image-21-google_apis-armeabi-v7a";
    path = "system-images/android-21/google_apis/armeabi-v7a";
    revision = "21-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-21_r30.zip;
      sha1 = "bbdbbb3c4387752a8f28718a3190d901c0378058";
    };
  };
  "22".google_apis."x86" = {
    name = "system-image-22-google_apis-x86";
    path = "system-images/android-22/google_apis/x86";
    revision = "22-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-22_r24.zip;
      sha1 = "e4cd95b1c0837fc12d6544742e82d8ef344c8758";
    };
  };
  "22".google_apis."armeabi-v7a" = {
    name = "system-image-22-google_apis-armeabi-v7a";
    path = "system-images/android-22/google_apis/armeabi-v7a";
    revision = "22-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-22_r24.zip;
      sha1 = "d2b7ca5f8259c6e4b3cfa5a0d77e4a088899cfb0";
    };
  };
  "22".google_apis."x86_64" = {
    name = "system-image-22-google_apis-x86_64";
    path = "system-images/android-22/google_apis/x86_64";
    revision = "22-google_apis-x86_64";
    displayName = "Google APIs Intel x86 Atom_64 System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86_64-22_r24.zip;
      sha1 = "cde738f9353606af69ad7b4e625c957a4d603f27";
    };
  };
  "23".google_apis."x86" = {
    name = "system-image-23-google_apis-x86";
    path = "system-images/android-23/google_apis/x86";
    revision = "23-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-23_r31.zip;
      sha1 = "877cf79f5198fa53351eab08ba9ce162dc84f7ba";
    };
  };
  "23".google_apis."x86_64" = {
    name = "system-image-23-google_apis-x86_64";
    path = "system-images/android-23/google_apis/x86_64";
    revision = "23-google_apis-x86_64";
    displayName = "Google APIs Intel x86 Atom_64 System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86_64-23_r31.zip;
      sha1 = "342c39df061804ee0d5bc671147e90dead3d6665";
    };
  };
  "23".google_apis."armeabi-v7a" = {
    name = "system-image-23-google_apis-armeabi-v7a";
    path = "system-images/android-23/google_apis/armeabi-v7a";
    revision = "23-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-23_r31.zip;
      sha1 = "da0a07800b4eec53fcdb2e5c3b69a9a5d7a6b8a6";
    };
  };
  "24".google_apis."x86" = {
    name = "system-image-24-google_apis-x86";
    path = "system-images/android-24/google_apis/x86";
    revision = "24-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-24_r25.zip;
      sha1 = "53dba25eed8359aba394a1be1c7ccb741a459ec0";
    };
  };
  "24".google_apis."x86_64" = {
    name = "system-image-24-google_apis-x86_64";
    path = "system-images/android-24/google_apis/x86_64";
    revision = "24-google_apis-x86_64";
    displayName = "Google APIs Intel x86 Atom_64 System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86_64-24_r25.zip;
      sha1 = "d757dd13ad9b0ba4dd872660e31b6506f60dcf32";
    };
  };
  "24".google_apis."armeabi-v7a" = {
    name = "system-image-24-google_apis-armeabi-v7a";
    path = "system-images/android-24/google_apis/armeabi-v7a";
    revision = "24-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-24_r25.zip;
      sha1 = "9a0ec5e9a239a7a6889364e44e9fa4fcd0052c6b";
    };
  };
  "24".google_apis."arm64-v8a" = {
    name = "system-image-24-google_apis-arm64-v8a";
    path = "system-images/android-24/google_apis/arm64-v8a";
    revision = "24-google_apis-arm64-v8a";
    displayName = "Google APIs ARM 64 v8a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/arm64-v8a-24_r25.zip;
      sha1 = "5ff407d439e3c595ce9221f445a31dcc35df5a86";
    };
  };
  "25".google_apis."x86" = {
    name = "system-image-25-google_apis-x86";
    path = "system-images/android-25/google_apis/x86";
    revision = "25-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-25_r16.zip;
      sha1 = "562e3335c6334b8d1947bb9efb90f8d82f2d3e4d";
    };
  };
  "25".google_apis."x86_64" = {
    name = "system-image-25-google_apis-x86_64";
    path = "system-images/android-25/google_apis/x86_64";
    revision = "25-google_apis-x86_64";
    displayName = "Google APIs Intel x86 Atom_64 System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86_64-25_r16.zip;
      sha1 = "e08b94903631d58964467b0b310c93642d85df6c";
    };
  };
  "25".google_apis."armeabi-v7a" = {
    name = "system-image-25-google_apis-armeabi-v7a";
    path = "system-images/android-25/google_apis/armeabi-v7a";
    revision = "25-google_apis-armeabi-v7a";
    displayName = "Google APIs ARM EABI v7a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/armeabi-v7a-25_r16.zip;
      sha1 = "4c49e0edb845b0bf1f231cb0e8598b1a9f9aa9c8";
    };
  };
  "25".google_apis."arm64-v8a" = {
    name = "system-image-25-google_apis-arm64-v8a";
    path = "system-images/android-25/google_apis/arm64-v8a";
    revision = "25-google_apis-arm64-v8a";
    displayName = "Google APIs ARM 64 v8a System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/arm64-v8a-25_r16.zip;
      sha1 = "33ffbd335d9a6dc8d9843469d0963091566b3167";
    };
  };
  "26".google_apis."x86" = {
    name = "system-image-26-google_apis-x86";
    path = "system-images/android-26/google_apis/x86";
    revision = "26-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-26_r14.zip;
      sha1 = "935da6794d5f64f7ae20a1f352929cb7e3b20cba";
    };
  };
  "26".google_apis."x86_64" = {
    name = "system-image-26-google_apis-x86_64";
    path = "system-images/android-26/google_apis/x86_64";
    revision = "26-google_apis-x86_64";
    displayName = "Google APIs Intel x86 Atom_64 System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86_64-26_r14.zip;
      sha1 = "965631f0554ca9027ac465ba147baa6a6a22fcce";
    };
  };
  "27".google_apis."x86" = {
    name = "system-image-27-google_apis-x86";
    path = "system-images/android-27/google_apis/x86";
    revision = "27-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-27_r09.zip;
      sha1 = "ab009fc1308ded01539af4f8233b252d411145bc";
    };
  };
  "28".google_apis."x86" = {
    name = "system-image-28-google_apis-x86";
    path = "system-images/android-28/google_apis/x86";
    revision = "28-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-28_r09.zip;
      sha1 = "7c84ba5cbc009132ce38df52830c17b9bffc54bb";
    };
  };
  "28".google_apis."x86_64" = {
    name = "system-image-28-google_apis-x86_64";
    path = "system-images/android-28/google_apis/x86_64";
    revision = "28-google_apis-x86_64";
    displayName = "Google APIs Intel x86 Atom_64 System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86_64-28_r09.zip;
      sha1 = "eeb066346d29194e5b9387a0c0dd0f9e2a570b70";
    };
  };
  "29".google_apis."x86" = {
    name = "system-image-29-google_apis-x86";
    path = "system-images/android-29/google_apis/x86";
    revision = "29-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-29_r09.zip;
      sha1 = "33d71d17138ea322dec2dea6d8198aebf4767ab3";
    };
  };
  "29".google_apis."x86_64" = {
    name = "system-image-29-google_apis-x86_64";
    path = "system-images/android-29/google_apis/x86_64";
    revision = "29-google_apis-x86_64";
    displayName = "Google APIs Intel x86 Atom_64 System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86_64-29_r09.zip;
      sha1 = "0aa76b20a7ad30f2e41bc21b897b848d82533d26";
    };
  };
  "R".google_apis."x86" = {
    name = "system-image-R-google_apis-x86";
    path = "system-images/android-R/google_apis/x86";
    revision = "R-google_apis-x86";
    displayName = "Google APIs Intel x86 Atom System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86-R_r01.zip;
      sha1 = "4e260bef94760eecba3224b68c1a4fed0fb89485";
    };
  };
  "R".google_apis."x86_64" = {
    name = "system-image-R-google_apis-x86_64";
    path = "system-images/android-R/google_apis/x86_64";
    revision = "R-google_apis-x86_64";
    displayName = "Google APIs Intel x86 Atom_64 System Image";
    archives.all = fetchurl {
      url = https://dl.google.com/android/repository/sys-img/google_apis/x86_64-R_r01.zip;
      sha1 = "ae12e1c3e1b36043a299359850e9315f47262f81";
    };
  };
}