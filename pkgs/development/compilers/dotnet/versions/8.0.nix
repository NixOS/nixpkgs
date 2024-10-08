{ buildAspNetCore, buildNetRuntime, buildNetSdk, fetchNupkg }:

# v8.0 (active)

let
  commonPackages = [
    (fetchNupkg { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.8"; hash = "sha256-5iWiiKBaB6V5x3GDvZ1DpyxDHFIsmewksoeIizz8Z7k="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; hash = "sha256-2KBKkVUlpiO1bOY+Ia2PKjurY2taV7CHnzU7Jr5HYUs="; })
    (fetchNupkg { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.8"; hash = "sha256-3x7ltOqJJXYO+zHIIvH1SDEz9fTrHqNoyK68teiHGZQ="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.8"; hash = "sha256-ZGunPQaL6Kz97BpQY9lSOPEsy1CvZiTZeidqnG18anw="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; hash = "sha256-x45oE7EFl6V29tVnuvzfcnAufOQjVf8FYxG8TSNz77k="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; hash = "sha256-UHKTFAfqIxoBZ38I6wBdMNA6NyQ4FhSJcHNQZxjaCu4="; })
    (fetchNupkg { pname = "Microsoft.DotNet.ILCompiler"; version = "8.0.8"; hash = "sha256-KmiA+uHHYOnsfdG3F20mu0XllcRxEvMvWkHz7vK39KQ="; })
    (fetchNupkg { pname = "Microsoft.NET.ILLink.Tasks"; version = "8.0.8"; hash = "sha256-st7UdPx9AFKf9o6WewsmUKhbP2IG2KQjHRCTdP4Vj00="; })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "8.0.8"; hash = "sha256-VL9omnR1wz323jyU+UQWPuwKOv7UfkkiZ+8ja1JYDM8="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "8.0.8"; hash = "sha256-MaWj6kbZ4td5Yq1aMyK1nqUva7d5bDXSewRoqjF0jS0="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.8"; hash = "sha256-Dz8dkFRN//VvdLjWxe8+5o81adh/gqYyo5aHxtjzoqs="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "8.0.8"; hash = "sha256-MJmQmBHWgvsqO8XYLnqsyUTfQ72VeJ/3EHq6OHtZ+n8="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.8"; hash = "sha256-dmtcy7cqijoJAUCEJTNcvqaRneRMCn7WJkurjk2YpN8="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "8.0.8"; hash = "sha256-liIF45Ljv47Wkl9xhN2IWH4vbFPCUkvF++i7ENsCB+o="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "8.0.8"; hash = "sha256-Y3KRiZ9i1IQoU/X70+c5hUkPsfSUJD8mrWecspUAEPw="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.8"; hash = "sha256-LACty1K+yIIJiTgArn6DpuMqKS+uhVBCgIG2e4W1XBI="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "8.0.8"; hash = "sha256-deYqv/tadlpOOMof1/MoLu2fIjcfbQ4Y/auc97c0GIM="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.8"; hash = "sha256-a6q/Fq88tknCNUEMiGAdCNOMj8rUyWMa3LdasqMl06I="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "8.0.8"; hash = "sha256-MeztjburvdAXPWL4eLVhvL2+K9qd3otNatH8QbJf3Mk="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.8"; hash = "sha256-Q7ZRUqGLN41EIbmTPQXiiLIJsLWwHHlTMCg7e9B38Fs="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "8.0.8"; hash = "sha256-nb0PV2g3PjENKIFLnnUynIxa9GWjVRyprHRbrMAfHW4="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.8"; hash = "sha256-exBYb8kUySdkudyNrs5ArXa/wkkS2b6lhVpm4jZMnqQ="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-arm64"; version = "8.0.8"; hash = "sha256-b6WidfvMYv6zHy1nd4kGc5oCg5tTDxPlg8CESjurv5E="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.8"; hash = "sha256-4OtC6HUOpa6DSJPkA+/72wQHgGj3Kqh7iQyJtvvNtz8="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x64"; version = "8.0.8"; hash = "sha256-bHuEFTwVzaQOEV1w/Jtfe8ZHMOtwHWsSqiiqoun+SkQ="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.8"; hash = "sha256-wTLpzd7iu6eCyOn6ct4ZzB2NQq7GzNUJEsh+zkgHbdU="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x86"; version = "8.0.8"; hash = "sha256-Q6mYxptkYaF0ThyJSX0uUVKK6R6x6Xkfi/40EqiDAQA="; })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.8"; hash = "sha256-H3XoUT5B3taEoJvUFhlTRZ5/LI8VVaFxd82QZejD+xE="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.8"; hash = "sha256-eYuDkv5aQvet7FzZOsZ5LZHnbNE4na74cmq3JsDaBNA="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.8"; hash = "sha256-UMSNfp7fmU9UTkCj6GFoqz4iLDpM1zh0WP9W7KBIMAM="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; hash = "sha256-lSBjAXq7gADmOA7NaK9S+S+8Xx8oTsI6Mrp3fgA3eVM="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; hash = "sha256-RZ3KnxLJocJS9mSAwP69XCe0kA/uCppUNSMp4soCkN0="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; hash = "sha256-iW0U93hxohZrnGYB4us1XAaOBXMtMofMlN/FVdVjSS4="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; hash = "sha256-X6iM6I4WpVbLCEDhwwUrih1801VKfFz3gAaYZuQMTxk="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.8"; hash = "sha256-wCNIvKB1pav/orE1e9Ljcb8NUiaIZ447KsyHtEI1uFM="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.8"; hash = "sha256-Yu/CZXF9OS9CtGV1ohPRRLHKpg3xZXmH+8aukhZjJO4="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.8"; hash = "sha256-hSj6/ogmBRNoC4VIqmkp7IsFcYf1IzVhHFsGU4BW/ug="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.8"; hash = "sha256-VXwu3zMEoxrLfABVIc2zIN22JsoUwCeuM7W++7lGeVc="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; hash = "sha256-GRldzHE2XXJdR6qAdcxgLcXZM1gNoiGsfJg0M5qnlR4="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; hash = "sha256-VACUGeR/lEFnS8O3kVBimN8U2sIr1/aU9hHyBA4cnKU="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; hash = "sha256-C3891F6er32h/x4bjp7nMbHOWvaGhjaAVxPwGQtxwtc="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; hash = "sha256-s57vIXMmdrTdlGmfqyemkSJP11MltQWemJnet92e+A8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.8"; hash = "sha256-HDpL4+yMCXuy05nnJWKqZB2KkumluhvznAxAglZ2x5o="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.8"; hash = "sha256-/9Hsru4pLWKMb2LTF1erdHILGdEc/2NnuTIG+dcf1jY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.8"; hash = "sha256-Leqb/Un4/GRgRcymCJWnPhjZCn8A2hl4nFdYJfkNdqs="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.8"; hash = "sha256-y5IbKOkqAKBpyWiA0PFmrtVXGXsWLHvX2FsiICm6egU="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; hash = "sha256-Ls2+jcDC4FW9zO81O2JP6BtKeazhydWEiXBPg/GJsfw="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; hash = "sha256-jJ7jGIYzDYqBZzJEG3BwS+NqUv7o7tRxUNgOTQ0oFSs="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; hash = "sha256-SCj9QjWOJvv3TvlR0TpIyFZrebRFTkVFVPdQ82F08gQ="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; hash = "sha256-LbvKpuOg1Rdqtabz1UvoADiNOkh+phBdXcD9iBGAAD0="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.8"; hash = "sha256-TwTvStZ7PMGpFh16lSI4iAJwDz/lnJkqHk/RQ0KEQB0="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.8"; hash = "sha256-p2Xix0JrQlMxDbvuPmXXaikVLVdKo1OPdk5w5PKSp3A="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.8"; hash = "sha256-shWbs109a6xx0JyJH1hwjs0OR/KhemxYjjLJhrTzE7w="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.8"; hash = "sha256-cdjNG4XehuADgSuW0c/PKC+6VA0rdzisUKYJXMPhSvM="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; hash = "sha256-kxAG5q8z/6d3jjYhIbEOLTa9sFUveg9AK9QWEYb+Osc="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; hash = "sha256-M881jx3YlNWC51BZguFtvn9UfU6neFeRhSaq0zsMCFI="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; hash = "sha256-BwC5R+ECo52tePjkq/B6OEQvS4hq8tlAfUOBi9UufSg="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; hash = "sha256-E6clBJ6GdZd3d6XaGqlwcyJq9UN4a9t+ixdZi7Ro4Xw="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.8"; hash = "sha256-epjQsC2vTOpppEuMljG78vm/RWecUu/YJRAt+2ETd9s="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.8"; hash = "sha256-DHGL/dDpQ6LhathaNJxp3M3qQcCEG9oYisUQ6WMurMA="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.8"; hash = "sha256-6hx88DtgvvwRhyEFHS32AKvRwwHZyS44SxYRG4La+i0="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; hash = "sha256-KdRDHgeE6ShPewlbreXJ+87JrPGdhO5CEGBzVOyn44M="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; hash = "sha256-g7De3JFCkr1wtMguY1QJXAZD5CX855/xen6pCMCrkDE="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; hash = "sha256-PdskfOr7EiC4VDvyAo5k5MjmKayexsyPNkJhaAhVXjg="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; hash = "sha256-tSZ9tj81dWrHqrau0in1b/ZgbMyDs5P9Ea3sofhQ/ks="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.8"; hash = "sha256-21RqIxjfaIOaABcqoe9AlZElWdXNd44dX0jodejOFNY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.8"; hash = "sha256-nCSziE636/NGvg4J8HKI0CZ48SZZvwKu22QZa7Q/sAg="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.8"; hash = "sha256-3vnqKFPAhjoLP6h/MnVfhoWOr2/0XvnUyufafbYED8Q="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; hash = "sha256-4zmkFZSBB46KjlubRHJ+DIBZs22CJLbIonT9hVsf57o="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; hash = "sha256-JeCvY8S+YPlFMwNokIxIfOsMc+cPSxIRozAVT03+ZlU="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; hash = "sha256-EXfxzK1Z7kqCDckq829GHat6EfYCKJ+9BrcBeHd1raA="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; hash = "sha256-oDjnxygsxPsy1Mgnx59tpmqikAgN5H4o3IBzXup4zNo="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.8"; hash = "sha256-xxkmlp9i3x/4Ii+e4YYMPAA4iWdK2cwwj4030tp3o+U="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.8"; hash = "sha256-ZB3eGK98abOZpcYmfWx0V3G/8AWr20gGyB/Ko5Zl91I="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.8"; hash = "sha256-L1IBy+DvMCZIbTzmlvSU2vsRrlZz7f29VS4H0+1/stw="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.8"; hash = "sha256-6G+7coU3SeYUTAjWl0iSYi28nGv5mzTnS8nkMMffGP0="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; hash = "sha256-O59V6pzicz7KWwUy+5qB3nAwSxhRsM9HoCq2uInaaHY="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; hash = "sha256-o3tSBAtHJGV5FbpreOQPF1VPb1ZoJI0unynfBUwvZ+E="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; hash = "sha256-NI6EnCoVuFHZ6mH9ZMXb38GhmQUhfxwP+vPlO/MsVnI="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; hash = "sha256-zvmCpjhY5JRezpwVr0S90rJfV0YGZ/wFJswo7Bl6tQQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.8"; hash = "sha256-D4qB2A3tJGN3nJcxMl/gBxA+LQx5QiawYWHn1Y3jWHs="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.8"; hash = "sha256-emanxsPDi9tYicfkeLRVN4r+yZq06jG2RdoVpRG/lK0="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.8"; hash = "sha256-x7WOZWhE4NX6yc5MBlFO4EKHt4ExhnGx6lhmYrr8wfk="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.8"; hash = "sha256-SWEUTsvHkPP9S8iRW/PrneIZV7NRkz3IPiVmKZ95X6w="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; hash = "sha256-bG/yxRP8uNHjCcZkSOlqSqgWIesuww8irvtSsC8jIfE="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; hash = "sha256-0EJXF7Aa+7nEUOvqMCDLr5Gwa9OWu/Ol5kpCymTVkP8="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; hash = "sha256-sdCf4IfySwQalViNicdX1NFN3obWCImm6I6Zzhu1pxs="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; hash = "sha256-jHU0GS/mtOjKniVojxzKdk6VgQghNLRWi4G0/W+kflw="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.8"; hash = "sha256-hBmQqsJX4lPCEkwh0kuZl81KNkqR+4FZWwBKaGQPPPk="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.8"; hash = "sha256-kWp27hqFc4GlvnFiiPZlW8F6UEXmFRNAN5RkkNfM0D4="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.8"; hash = "sha256-lD/M7PhWXUSsS3FJ4doXNo+zFLIAnhqBmtfBkDvOX9U="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.8"; hash = "sha256-xJc8ynP8Yaq3fdBrd+1wSgF02dx6fKaO8Ty1JJvm87w="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; hash = "sha256-/1nQT+3thlkAeQbfsIakuD+/oZsq9KeI0vCgCFubOO8="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; hash = "sha256-2P9wZVY4iQmOxKttjrqb2fKQMWHzupFgVuwcE4egAOU="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; hash = "sha256-ZTK07ZSjid/flmTDgrp/GH37rmYpOYdXTKzJnEeIx3k="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; hash = "sha256-Lzxot9nzljMCvyqLHiXOu6qC3rgB3iN6JG5t1QCAbko="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.8"; hash = "sha256-NmsUnkmjpbxYa3jNjLa3+CbbSa1ipFvolk6fjJQ52co="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.8"; hash = "sha256-pkfKvNeb779TUp9jp19peJjCXK3NGpexaFjWwc3dSBo="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.8"; hash = "sha256-C0zUiMMAQ9nd1n7PDVoBhCShHzdGI67YFySTpeFH8uE="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; hash = "sha256-ojXEKX1OwepAx61seCAPh27UATzGTsE6VenT061IOmU="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; hash = "sha256-wMhsf3QncEUGSnFrGEck2Kyb8cPLPW8n7ZgKHwebdI4="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; hash = "sha256-AGqQ6fZicft/cBquuHb9jOh10N8gr/sLfijYzwm9vcM="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; hash = "sha256-hl5uj5iR2xXkefLQJ7DVU0NfThLatJUOqm9MGZUN9HM="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.8"; hash = "sha256-gS1Lu8UcYwlJL+N4Q86NnObCYOjsaG09+bHbjXr1Ro8="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.8"; hash = "sha256-z5swa/BoIPh7oDb4WpAh5uvXZ46artGD/lnQm4e2cko="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.8"; hash = "sha256-fpqkDTGVOO85fWS+X5Yj//NRkVoRf/RxJZ974N4OKvI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.8"; hash = "sha256-nZEdf9Y3TLgyLOzSpn5ryl4xAbIy1vMGnVqCcYr4G74="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; hash = "sha256-NDGG0iZtxXLArTb3DEF1ELT3nHNTT5ogXqG00+70f9s="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; hash = "sha256-QYpsPJMunG+1LY6iOhkqe3TWZeUnV2sFdCRGKByEJcg="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; hash = "sha256-B0EIM5Jxi367oSvB1mHiHE3VpdoE02OF9FbFC1FlkLk="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; hash = "sha256-y1V5P/emZwwzWoz0UtMC/OYQjK+nGe9vkrY4RE9HRVI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.8"; hash = "sha256-vz7hG4LOgtZVpOMCCDrosxSiSUAIFmHWHxPe2kfIAWo="; })
    ];
  };

in rec {
  release_8_0 = "8.0.8";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.8";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/26f16795-9928-4ddd-96f4-666e6e256715/bf797e4f997c965aeb0183b467fcf71a/aspnetcore-runtime-8.0.8-linux-arm.tar.gz";
        hash = "sha512-0P7t2Ru0AoBp2M/xcmGR6fCZIOdWQF3g0rv29DEWJ3zJPr4kg/QFuqSXK1T/6JsJy+FypjnmA5eucTjfXvSMTg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f6fcf2c9-39ad-49c7-80b5-92306309e796/3cac9217f55528cb60c95702ba92d78b/aspnetcore-runtime-8.0.8-linux-arm64.tar.gz";
        hash = "sha512-w9ydcfygpI7algdMvO9MmiZcHE4Qy/84YU3XTXlEOunRzNEHFHZM0EEpH4HYPA7Rwwer+JJJq0tvWKXelS/P/Q==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/648de803-0b0c-46bc-9601-42a94dae0b41/241fd17cee8d473a78675e30681979bb/aspnetcore-runtime-8.0.8-linux-x64.tar.gz";
        hash = "sha512-1sDMKqx5+6y/gbWX8oZ2NZn2YnjBfdtEjOC5PUmbrY+Id31CWFTmhgKUWrGK+KYfHuWdQx1VAwBhN/hhE/qosg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/9255e487-cdf2-4690-9840-74712503e37d/40be3d122db1d1ffa53a9843321c3979/aspnetcore-runtime-8.0.8-linux-musl-arm.tar.gz";
        hash = "sha512-XZ9gnnLc/MFra7Y9Sef9R8Pi13kT2d4UhkQX+ypTSy99tWUw2xZazGNjNkHHBtD6upXbmFsJhEZ32MtBA5oMZw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/95f358cf-86b5-4789-8ee8-063067081c8b/e50e603b2453d7dc65eeb26dd4cfb398/aspnetcore-runtime-8.0.8-linux-musl-arm64.tar.gz";
        hash = "sha512-YCjCkwbUlp7kBMRZ3KMTDx6WFNGVTo7UQAFAs1rYoeZqCos64CFV32vQRs2TCQdCIEh6HCYlw58IG9xsjtYgBQ==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/7d2ac05d-2bef-4069-9513-bb2ef7fab48d/4f3d2d3fec003a65513dc1f70c126ab7/aspnetcore-runtime-8.0.8-linux-musl-x64.tar.gz";
        hash = "sha512-gi8uFxbcLSqkb/CPTS2bueqMgjMnhdCrpfTzPl62C9zYTomc0qE8qTAyImcQtfDKXHFZvtoXAn+E76KFJ4tXmA==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a7080974-fac8-446c-ba20-313f6f323fbe/f907c126c9bcd394939a7cdf86b85f4b/aspnetcore-runtime-8.0.8-osx-arm64.tar.gz";
        hash = "sha512-oZbGKxTpE2NiBzgmoD524KFHAn8DZVUpQm5ZT35E643QNtrqgJl4dgRxccF5PH7c+lFGvVWgG1kdlAX7FkbrAA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/465bdf6e-407d-4512-a222-32dafb225ad8/c22004de330d10a06141dee0f42b5d12/aspnetcore-runtime-8.0.8-osx-x64.tar.gz";
        hash = "sha512-07qNz63c1tUP1DSRH+PrgwlmaTmooe3oANfaLdgU7714HRRJpCtx0ccdlZNGXp6XIFAl60MoCO+aO6DcvboOPg==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.8";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5e427de4-981a-481e-9fec-fa77b02a7edb/0d156acae55ca1329b6b9a8de70f398f/dotnet-runtime-8.0.8-linux-arm.tar.gz";
        hash = "sha512-yHr1qq8y4YzNwpZRecZaq65eDp6Oogn2w2QnDOLkr//ql5yiLhQ95GdONqKxLGa1dViK4hnxZjaspxIUQCQCiA==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ac04b123-0542-4e80-9216-93f51a6814b3/d110733c152d34ab4eedb435ccfdab4d/dotnet-runtime-8.0.8-linux-arm64.tar.gz";
        hash = "sha512-JG+35e21Hbk0Ica7dCD3o1hDC5iyJKcftw5xorzgvJH4U6qJEJ8hiLCrKFMqJFw9UrqsFjRj4BoCAZ3qN/058g==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/68c87f8a-862c-4870-a792-9c89b3c8aa2d/2319ebfb46d3a903341966586e8b0898/dotnet-runtime-8.0.8-linux-x64.tar.gz";
        hash = "sha512-j1IgCYxWL6NJBBd0jrn0+coVUfcVVyi567GSQ1nGPBje3vZDvNiexntZy1sbnecoPuFW7zgf+xaAG1FtupsbDw==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2f4507aa-972d-429c-9129-cfe95c1279eb/60dd9afc3f4786a568b01119c2280c63/dotnet-runtime-8.0.8-linux-musl-arm.tar.gz";
        hash = "sha512-im+SDZPX1VJ9won0clIeKmca+05mOqrP2CwyZYwuo56rQ6XJfT09e6WEA+v79suW/HP/W3zMGpRH0Tv0HuuAyQ==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8d78f160-0833-4db5-bd62-947f8bc2d571/25638f47211018a7bd8fd9d314763196/dotnet-runtime-8.0.8-linux-musl-arm64.tar.gz";
        hash = "sha512-JvNeHGB0p9maQOpI9sAtt49OLHQ8vHRGOglNoBThJuk3nQm05WgJrJgpsmtroKkBrcR638PF01qX6erVppMUiQ==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d9c4e4e4-bb2d-4f1a-9ded-bff5e354bd5a/0c6dbc5f68bea36a65fdf80e6aa4d55f/dotnet-runtime-8.0.8-linux-musl-x64.tar.gz";
        hash = "sha512-yi/zIUVQZRMlP4Ds1ytcJNi9oo9EroPJiMOev6dec31VELy4S8J6FJ0uaZV2H4sSTXcBUirpu8rBf8MmZyF+tg==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e9ded115-7a30-4952-bb72-ff101583f20b/5a7628261b98d095d2c97ec3fe5267be/dotnet-runtime-8.0.8-osx-arm64.tar.gz";
        hash = "sha512-iLBt0FGBm9noziw0CyUW3A5Kd9Vl7/FF2OlXslUqZB4jWlzn6Ns2B0dYh7x2bxUw0B0Ofv2A0QzWUqKZlUOYtA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0159972b-a4d6-4683-b32a-9da824d5689e/ffb0784119abf49015be375b5a016413/dotnet-runtime-8.0.8-osx-x64.tar.gz";
        hash = "sha512-gCmYbB+LvxsOjQkpdWFW/kHUbS326+GrHGb7zqKt1Hw1uTRXPGGYeXz2DSs3LNRj5wMmwKNbCSbatNXBV6NX8w==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.401";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/788ca4e7-c3ea-405d-9f82-2d362d4a08f6/d54b1aefd4048bcf4eebb24edfc6aeb9/dotnet-sdk-8.0.401-linux-arm.tar.gz";
        hash = "sha512-+5Co5S9d0p5ZU+RmLMnVfKqW3GqPb/bPrheUeqij9Ttf7xuzW4wFgV+hyvvccxefcpbOhGv1dp7hLJ2vW9J5QQ==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/14742499-fc32-461e-bdb8-67b147763eee/c14113944f734526153f1aaac38ddfca/dotnet-sdk-8.0.401-linux-arm64.tar.gz";
        hash = "sha512-6HOLITUdAwqDvmRFcfNnTI3anm+9NgsiGQenEI+rAr7NGOEzGQdTWhKU2MTQ9ghRlnTCfHfcLCgDzFPM4+EODQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/db901b0a-3144-4d07-b8ab-6e7a43e7a791/4d9d1b39b879ad969c6c0ceb6d052381/dotnet-sdk-8.0.401-linux-x64.tar.gz";
        hash = "sha512-TSGA6CyWMxiGNHbPYcA1vT2CFl57cHUbojEiW1V13yTTDAeJ1XSMOjeeHmiWtX5ZKGIYys1ED/sAdck1UJT9jA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f9eed98d-5e19-4822-85d6-c59c62376bad/52ba188eabe759516711f14247c57f7a/dotnet-sdk-8.0.401-linux-musl-arm.tar.gz";
        hash = "sha512-xcVH6zAdyWXu8dm8xkIxZ44glZG4AZengknTXRZVpUafOc5t5lQ2N19uQtItFZw9xIe+F/bb52NAQAlfyYjbIQ==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8f3dec03-a016-4c06-a4b0-04efcffbe521/e0e94170cbed0aa9312be63e43a69932/dotnet-sdk-8.0.401-linux-musl-arm64.tar.gz";
        hash = "sha512-L6q5PdOKSThgMgg6D0o6WlZh1uz/SpjwaO16oHsgEjOAT6Dl76SRG27r7cmZTVnE1dhD3rdz5+JieyqpfmNKgg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3ce68ecc-a007-4d15-9196-79ced76a154a/6a45f69bb5c24576abeea048cea09987/dotnet-sdk-8.0.401-linux-musl-x64.tar.gz";
        hash = "sha512-5xG3SDImlGPif5iwScRC02hM3CExFRMyhaKxie9FZLZRJ3R83TqQDeU1gQGb349HQm8s/Jv8HAw6gxBvm7VOpQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/29ef2c29-154a-4c44-9450-071ae664767a/4ce00627f3eaee13874b54f033a9a27a/dotnet-sdk-8.0.401-osx-arm64.tar.gz";
        hash = "sha512-oyMsBpO0HuaxjcPIsm2C3ZEWEyvXhx3JwKCsxeeZXzUudghp/pGgiChBfqe5H8J4Wa7qRJue+rwXwTaldzfJPg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b266f183-c677-4f93-a729-abe0334401ea/ca0ce4f684c4cfea2d372223f9c67cbd/dotnet-sdk-8.0.401-osx-x64.tar.gz";
        hash = "sha512-Bjrq9OlJuW1QG3eHMnnwKGzeRvkhK1kYHG2yFjBAH9ajUuMlmEjO6OEn5M6shaJeC842aZovtvbiqRmXxvYerg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk_8_0_3xx = buildNetSdk {
    version = "8.0.304";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c73041ed-e684-4dc9-981a-2db502409dd7/0e24c20b4b1d0a728e20982de0b8790f/dotnet-sdk-8.0.304-linux-arm.tar.gz";
        hash = "sha512-MbSFdO52Ow1BggwfSWs+BVNsa2n9bnZBJEsc1l3MOy7V77SD17/MPC/O0v5OlGWJpY4kTdxaExyyZUgiAYwNLg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/be9572a5-bcd5-46a0-b10d-0d00229ad57c/b80d3adb25c20fec467bd33f29f9a1be/dotnet-sdk-8.0.304-linux-arm64.tar.gz";
        hash = "sha512-bOk7ozCEi0BFtsY/lq0KkcR0Nhywogi9QSjUGP1toEaVVZrdY9+aCs8oOjLm54EyjTl5r5AOCyOCzwBsmYKAbQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/52cedf32-8a92-4966-b184-18404ea1c5a4/cc399fff1b152b822776514ad247df50/dotnet-sdk-8.0.304-linux-x64.tar.gz";
        hash = "sha512-lxw0Q3kkDsS/qvHsppxmZ+WUzdDf3N5uiWLLekHWad/5HGROSO7TVz2EG3s+YM4C4MJ6fON7Zs3sJ780Vwh8Sg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/21dcf586-94e5-44f2-8407-bd409d73f59a/ec99c395aae24f38dd5cf91c8dc06fd3/dotnet-sdk-8.0.304-linux-musl-arm.tar.gz";
        hash = "sha512-0tEHHGdGZKj+lvYaYgTFb54sZZjSoR406skWX/MNHNMxGeEOeUmamjVOxGHjBj5Ad3KzYvNkDmQRTNzSpO8Pag==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8083f186-347d-43ff-ac05-575f63a1c692/dfbfb3ee9943b880472ccb8e5517a881/dotnet-sdk-8.0.304-linux-musl-arm64.tar.gz";
        hash = "sha512-8mbyyMQFN32ExPGRegxKdJMJfMhTlA7hKQ7vyHdzMZNagAAqnGx8AxmP82YbyKui6TNBXYp3iUn/kB2ov9qNGg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5cf9b56c-0da6-4229-9e30-44547aba8be6/20d2e5353050b04d3272aa5c4a1b689c/dotnet-sdk-8.0.304-linux-musl-x64.tar.gz";
        hash = "sha512-QdptR5cqfKZ268Bxhh+jxW8xH2PuCff+A8wJzvHkdx5O/nPF/GsCq4TwB8LnBE1+4WxliXH6hW1T8V9D5qYdmw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5ba638c9-0721-42c5-8bf8-9706c0f9c033/f8dbde51758bd9e734a9c932b60e12bc/dotnet-sdk-8.0.304-osx-arm64.tar.gz";
        hash = "sha512-aZOpULxb/w7+diuiViqIdh6TxhAk2TYzIJlQy7aK61/xify/6SR6HN67435zgTYSPH1O2hBQcIYIux/wQI7/TQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8b5c27ce-6c82-4a06-8960-15ebd5434595/508572144872e190e7f00ba6583011d4/dotnet-sdk-8.0.304-osx-x64.tar.gz";
        hash = "sha512-UPAmVDbow9dWugCrf81gbLXUUte+3k2vl+TALMl9u6/AC3bzfsTwe77UvuZDpDOEndvTY60tkWqlll7nS6MX1g==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.108";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/27228a4b-1ae9-4c1f-8a21-eecd21d6c7b8/c0500c9fac6db54f68c04956b828e8ea/dotnet-sdk-8.0.108-linux-arm.tar.gz";
        hash = "sha512-+vqFZLNLUktCCeEEfOfPEZCl1C57obE1JPXeYCsHXmMM3SKVZ/FOsvCubJaskQrp27T8TlKN+VjJ0xRxNB7tyg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/07df5bfc-98ae-4335-91c4-c95ec5f99a58/48a310e5d1bde3e77c53a51c99bdfc08/dotnet-sdk-8.0.108-linux-arm64.tar.gz";
        hash = "sha512-bMcj8rE50ZsuF9pZNmmNOIpbZGOLde94xAxAftPP096nRcKRbwPvyeZkefxV1gjrOokwVyfs2xyZmxg7WN4ljQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/95a365b4-ac3b-4300-ab6b-54cbc73220f4/4aabad928064af8761315ef34b08c24b/dotnet-sdk-8.0.108-linux-x64.tar.gz";
        hash = "sha512-Vmbd9vqbZd6rpNfF/MLi1W9jHE9fb7Kp9ZGa8GFqsrQgsSqCi+zC5LhiinasPa6CS1Wr3lxtWsWe4THX7Ornwg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/24ef2f24-ca8e-4c3d-8466-2311550147d4/acbf2877ab4b8a611a3b63a9b9853dfc/dotnet-sdk-8.0.108-linux-musl-arm.tar.gz";
        hash = "sha512-77MI2BrBAgli8U0D58qUGaKQGghGEg4HzZXGVAf+KYGiY2DC/+oUHYBYGqxtLDanN5x2wHsvs31O+4NpBfj/aA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/63bf0f75-e962-46b3-b7c3-12aa20129d46/071514943265037c423e6f5e40df7ace/dotnet-sdk-8.0.108-linux-musl-arm64.tar.gz";
        hash = "sha512-5wCbo3OwQ8y0aVVycayK5RirnJtbNk6YQdi5cwW2A28zJA5nLnxIN5hhaiM0KXSNUDj9/TNjUrggYK/WRXRwRQ==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/cab77c39-2e16-4f29-a9cb-e490d7fff442/ee37bc88e34e082a64d834ed5041bcee/dotnet-sdk-8.0.108-linux-musl-x64.tar.gz";
        hash = "sha512-dEcVUB3jlG8GzTFvNcq8DjY+CvZRBEyXZwjA1I1OsNCUidkszrKDx1Gy7tDik86qq93Lq/fCXiHWWOv/ncMEqg==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/64a3d858-c2e3-48d1-8236-7c6702efc1f8/191bed6c7f89244eb998b0f186db57d7/dotnet-sdk-8.0.108-osx-arm64.tar.gz";
        hash = "sha512-g7ASdkdLS2K/CigvvhHSNTohkdkL7NQDs3PNbfyVJkRCqQcRetj2FXZbE5aSZ7iH0mqfJNvV+I2LVdqpRBLRPA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5ea78b09-65a7-4b08-ac65-bfae17afb322/7416ecc76a30ae4c77e71aade36e037f/dotnet-sdk-8.0.108-osx-x64.tar.gz";
        hash = "sha512-qA/uJ5q/61WKVUDKKpaaEbs9vq3ow52MR76KLWIu8cK+2yLIdFmK1B2/8rldWkMZe9n1X8kzq07eXty2p2z2yw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
