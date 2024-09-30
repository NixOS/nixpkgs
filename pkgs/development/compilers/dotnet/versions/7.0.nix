{ buildAspNetCore, buildNetRuntime, buildNetSdk, fetchNupkg }:

# v7.0 (eol)

let
  commonPackages = [
    (fetchNupkg { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.20"; hash = "sha256-OEDXXjQ1HDRPiA4Y1zPr1xUeH6wlzTCJpts+DZL61wI="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; hash = "sha256-9eXw5iN90VSlSVxk8aJ7Dpt3DXoQ6+obVwk7WFOKOQo="; })
    (fetchNupkg { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.20"; hash = "sha256-W9RU3bja4BQLAbsaIhANQPJJh6DycDiBR+WZ3mK6Zrs="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.20"; hash = "sha256-sqHkR/XrTrjoZCz2sSIMl6UaURtLvO1mnNEatE22RDw="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; hash = "sha256-69omZXcSM0rGsyjo1fWzwV9tIi+P1nnywdt55Nf0jbY="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; hash = "sha256-Xvy+zEEVSrHbmj/HrNlgmxLb4tOHh+qWfgm9SZ06Nx4="; })
    (fetchNupkg { pname = "Microsoft.DotNet.ILCompiler"; version = "7.0.20"; hash = "sha256-Ctj9D/SUldo8X8lYSQ8N3sRNDM1CJDs8FKIaOYgwJjE="; })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "7.0.20"; hash = "sha256-49IpwRkt/aFtEo04C/CPeDu9eyluyEdGckKwhhZc/hc="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "7.0.20"; hash = "sha256-nizaX/VWGrez3oNq+ZVDomQ2Zo/Xj6LyRSP4K/myOQc="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.20"; hash = "sha256-7jC6NKfeXJDowb/aFpzSSWisrGt/mzu+Zt1hgr8Lg4U="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "7.0.20"; hash = "sha256-dB4YPadHp/mRoCILrYOvEgjZNkwz3FBUTxgABaL3CTw="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.20"; hash = "sha256-LEwD4BQ/jVdGK0ve2wL+7ZSSgCBCd1Ta2sft5GYG1kc="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "7.0.20"; hash = "sha256-AjMZmzPjcYwi6X9jrLWGpKlWphyKmKFPciqr/pzycPc="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "7.0.20"; hash = "sha256-W09vX3P87S+vp8Uoc41vK22Y+m8utMjA/vylLkJdR+Q="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.20"; hash = "sha256-UdYeRmRNstyV4QFiNOmfQWARN9/j9ov/37tafcod+CA="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "7.0.20"; hash = "sha256-pK8z2e65ndErBa0LjOSuKTNk/MIW3f2kUDWOrxseNA0="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.20"; hash = "sha256-jsGx6b/etx7Zj1FqvZQmGbBBZzPOCGvJSFFhLdGoiNk="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "7.0.20"; hash = "sha256-7MhZEjvvJmJSCYFy6skpATI2K3dwPyiigftFMrjY5lA="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "7.0.20"; hash = "sha256-h0AmMfX2/p5C/zevrxBuRmqHUYtmHFfNz4bhcBNJayY="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.20"; hash = "sha256-bTRNP9XkXibYWBVKaJ6gNtm00pEzwKB37zO9Nd7QHqw="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-arm64"; version = "7.0.20"; hash = "sha256-dXex6q5gQcBJ5Xccf27GxrTAvTlJyTC5i9Ln0IWBjJA="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.20"; hash = "sha256-YHUzySwU/aC6y2jGNG50RfDE+VhDLWI1ZIPMZNBC2JI="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x64"; version = "7.0.20"; hash = "sha256-5nZu1DgEqIy5HufEOE/4wyXuVyUWSozmpMh/+kqt95A="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.20"; hash = "sha256-Kg1eO2qB6EwXn6R/iD7/lvA6oQZ+crbvleCi4P7GUr0="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x86"; version = "7.0.20"; hash = "sha256-T6M4ND0K6i9CI5g08rgaPpECR2968YsJ2+2N2FsKYz4="; })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.20"; hash = "sha256-h4AheC6chrmBEjSK78h9yOpNXYoQSlDI1CGoc7KhYSk="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.20"; hash = "sha256-1F5YHSdEbiyGc1xV354GMoZPMuchTwDc3eauJc2RyDI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.20"; hash = "sha256-DO65UGqysAkmdSySTe2uDZ5cxyQuE/SNi4efOorhli0="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; hash = "sha256-zn/CNvUAe1E8oHLYWZprUZ7UNJ+300VxzeZsAM4qJyo="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; hash = "sha256-ZgMgi9v2RAa2wkk23l9ePcTe5gD8dNMppBo+BeU8cMo="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; hash = "sha256-pxYigP2+YwTjOyFc+iwrZsJPCrz9lZBJthMWre2bukw="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; hash = "sha256-MDifMjIVLWLS9QvvFCXLNEHepy/nrBuWKqDHRv26lM4="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.20"; hash = "sha256-OaG6rZCULgf2WZsp7jMgV4Se1S3niS4NYUPeogMv22E="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.20"; hash = "sha256-ewal9R6o20GV0R02ylSijVFdWZAbdN8TK1PCc/ltHBQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.20"; hash = "sha256-/20dMbO1Ft0WVhl+Lv1916Thvr4kPP9LuuX4bKE+czE="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.20"; hash = "sha256-TemMvbNrDzJVHWwxVgnNN2CnTyI6TcvvZDpF4ts6IAw="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; hash = "sha256-6tnGTUx1cW55ozpy318SGj7ws2GcpnA+NJoyRTGX+44="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; hash = "sha256-GmDatrpoKSn7bL7RXlyuLATyOE9kjmxC0m8ANlzjHJc="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; hash = "sha256-BmtD7+bB5Jb6h4/jJurNcNirsdaZyUBjFPP4V3ynXNY="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; hash = "sha256-osY7tcdNIos6uEZHLoEHnefnPhs9dlGxIgQUq5X6lzc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.20"; hash = "sha256-RY4H/RaMTcnvwJ7wclD/1Vf+MGxwXYbjmNAWuskaoYE="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.20"; hash = "sha256-vq59xMfrET8InzUhkAsbs2xp3ML+SO9POsbwAiYKzkA="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.20"; hash = "sha256-Y1Dg8Sqhya86xD+9aJOuznT4mJUyFmoF/YZc0+5LBdc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.20"; hash = "sha256-L+WaGvoXVMT3tZ7R5xFE06zaLcC3SI7LEf4ATBkUAGQ="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; hash = "sha256-wW2PXWx4WRSAWnajhB0NL4+ke9RqDBOAwt2NxW6Iu0k="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; hash = "sha256-jGQhaLwcM43JvQ9dQ8PTKSHcPVSTczXSTllfU1OyiiU="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; hash = "sha256-jgxTfSjd9bpDI/0DLzDpyFeOLOaSOxMjlAt5a0LUv0U="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; hash = "sha256-hhVsXE6VLAKGGmGoRmaFD/HtJPJ+7bWCSbaZFOCLvsw="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.20"; hash = "sha256-0c8Fm3k8c+tFh2Pa/2nYGlDGvOzll15feQyulbgE5gw="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.20"; hash = "sha256-fBn8P8fAtg49BnMI1Z8XBMwPqQNcH7qQOERctMfvBuE="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.20"; hash = "sha256-GP2mOs+2ozH6wVTsukdOL2c1DMyO7GRp/pxUg5K7bIU="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.20"; hash = "sha256-jO+fl14WkTkmVv31Au0VKCJAHXkEkzjfIgaQmRoNACs="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; hash = "sha256-/0Tww75oid1FnbVUc4j8nJC/N5/kZE3/BMGbffokiIY="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; hash = "sha256-4BvbIOvsS1FO8yIpJQSqusVvwXtEnSb/MgEPTZXfvYc="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; hash = "sha256-CEg5E9cMf9HLtDLb0pIhSX66jebW+ifxbEvtXgGq4TU="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; hash = "sha256-RmPCGQfi02r6mcYel/7WnAJ50ZdJIoum0px+ZcwfuGU="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.20"; hash = "sha256-H+de/nhNSKXug7pXxceJ6/dqk6oPx0Ft0ag72lk6JnI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.20"; hash = "sha256-dWlAyHp79GyqQmhOBOC49CW0rBCbrKtTQKErE5sQ3wk="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.20"; hash = "sha256-LW2us9viecZAaLSqo2WCAaXHCc8FZ+NMlrIIlYVUFNI="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; hash = "sha256-EnJktpQWI1sDKr8Pl6FxVovDq1FKVv5HU8JBNqtUryg="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; hash = "sha256-piJJaS5vCRBSdgdVP9xNI34SXXhG9KReSj8NuSVqXnc="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; hash = "sha256-dRz8NEBSp6rAwCQbGgjgzHB/pNvXlSiDyYDIOz1DV6I="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; hash = "sha256-yj+HgR7Jcbm/nKLtaXKq8EMNiQMBeQcFPnlqGuWxzCA="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.20"; hash = "sha256-Zhe1PbrJ7MRVFgAgcGyapLuArirQjLSPOKmqdnpG8S0="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.20"; hash = "sha256-XbLOKo0ABmdTOM4uiyXdoy2Ak3SRbOkmtgxtcl0Wb3M="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.20"; hash = "sha256-5haonP+KFrshqSmU9fy4Obfi6hddj4ZL02zAI7YVufA="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; hash = "sha256-fQHA/YcfOOZAY955cr1zIz3Jb/WnA6VVDWsOU01gyIc="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; hash = "sha256-VWdYX/oASDMDmuGF0nYGe1gm/uNxvOUi0BvV+1mAuJw="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; hash = "sha256-ck8dAXwoBW5tT89560rEspAb5M1dL8U+j1uohtc5ASU="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; hash = "sha256-+fq25MGwc9OtJl8+rBC/Z4AyUIUz6ScoUiRAkludC6A="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.20"; hash = "sha256-ahzHLCX9TtCvZQ/o/uaOTuzoMZzBy1bcmjBA7q4hdOU="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.20"; hash = "sha256-PHBb0AuRpB8kkQvQJIJSLu5Ub/U2pYA0wMGBarUkS8o="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.20"; hash = "sha256-MTyRTWhDmMaCsNorju/tLb0w+ssKydDX/NBFzSfqB0Q="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.20"; hash = "sha256-VHmF1/ObK5hxGYvm5/+pTdketHnxxcnAGK5RaTQpVqE="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; hash = "sha256-YyET6SqeoFDPk1FdQC6j7OJJzI4b4vTGVPwOmdGA1Qs="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; hash = "sha256-nAxKiA6PWHza9cjM9tncakHvK1tbiFyEViZJdI1iK2k="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; hash = "sha256-9ml/nOY7bpw8cvJhW89n9XciHjqx5uVpOSPxP2ksItY="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; hash = "sha256-7Rlb+KH9/WTP6old7VA+2rHU7rV92See+Rip7YriTpY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.20"; hash = "sha256-5OvsPNFOG/ZksgTEA5ESSfqt3+nOc2F4qSUvrDLlhL8="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.20"; hash = "sha256-+MQMRFzfG2CbNJnfw0buP4VorL2yR+T4UeEBSbKSmPY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.20"; hash = "sha256-DdumMpP5QN0rPDsB8sjxACM13mT7Wbb0w3LaCe96twc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.20"; hash = "sha256-yktNSySitxWbO6LjcxUuewWFMF2EbcoM2w18CqxmVlc="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; hash = "sha256-iMYmS6EWvlEw2acxRgWe76nwchR3DimtTl7w9iqu1+Y="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; hash = "sha256-hyuWvD5HCStp5Vd3tyr9hZMOrbrhLNbyalBZE7m6K3Y="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; hash = "sha256-uxdaALtA66S7yuS1mup93VcfuTzJRjmk7Mc0azi/GR8="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; hash = "sha256-W1umN/OuIvxHDXWMzkp/xRODlxBE478hElhDn4J9Uzc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.20"; hash = "sha256-903dIh6rx9dFUKvE7FUCdJMYubnbwjjo/95X0G6Blzk="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.20"; hash = "sha256-/hqNukz6YVNNcsRz4j4o/YMZOvLJ7QGOo1mdYp5oVVA="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.20"; hash = "sha256-h1zjOeQk1iTdX9lfiZHhnT+q6ntGLR+gGCfmu0giv5Q="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.20"; hash = "sha256-nAMDc5cf2SGMTuOOE873SmFf7iI5s58D3he9VlM9o48="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; hash = "sha256-yE+B690YZ9FbfnObaOi4sRcLPirZeHnJw0kaSMNi4Ew="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; hash = "sha256-flwlrG6e4n09Pn0cDMS0u0pdTbkQIUpltGnpmiUqJOM="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; hash = "sha256-Jv4vTgdr/HQijmfA9xAPWxzCSbZ91TvTH5nOAlu7A5Q="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; hash = "sha256-gbrJT1aisCWvjwNP3cuJc424w6+91ExcwlEkVUaUrSU="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.20"; hash = "sha256-lLn+6JAmx20z3Ghvxr9Lb4gtF/bFOEUPa8WKagHrVuQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.20"; hash = "sha256-EWoLS0ygXAaUk7LPrMpaJazIQ6qGZVHblUX0tAB6NQg="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.20"; hash = "sha256-DVR3W2IjXoQYRSksF2bRk62nPrP2arDA3CSEH2f9YbM="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; hash = "sha256-PX/TZQe5EBdh84DBKfLYHp/8HFmCqLGTYmhpQR1EYww="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; hash = "sha256-v+pfJq1pdSE3ejPRiQtbyxaGEV2vKOe5nCeTL2wS1VI="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; hash = "sha256-X2ox8EJBmf1mhLTByh9e5BnUCWV04VjWjjMWI0Y6UJU="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; hash = "sha256-WnpYP7hvPuBQSSGvQupeHNvGnwi13s2HQSKJepw438o="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.20"; hash = "sha256-xPeka8TTwkAvi4Omz8RK2z9GhMMaTD4No153URhft/8="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.20"; hash = "sha256-DBXJXKjkty9sR1xOfgQZrmPxuZegn/VmU5WjMab5Ddg="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.20"; hash = "sha256-0Ira9rw0tO25f/SeCTSD0z0bxgU7lIREHnrlZgXS/Uo="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.20"; hash = "sha256-6PjyKEhIrfW9MLIaTfAY4SmuKS0wblxaR9qaQ8IV7nI="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; hash = "sha256-Xq2ru5TIgQi4j8aV9dzlqfNuICPlAna9IKMTRYrGY6I="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; hash = "sha256-Kw/jAf+N8O2nYwr5KWnEaNBP4eq7IjWdBMtAX0dH01s="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; hash = "sha256-KRUmKJVPNVSBzDA8Dsh57CqTeCyPpmKjNIVBmNz0gRQ="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; hash = "sha256-3sgzxd64Eml+UxMSrYiiwNNUPpW18PSy3LkxzXCstCU="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.20"; hash = "sha256-hWTh4eIBf3ra9GE0fYrCjDNm0aT+4NjwCgr1X4VLHMo="; })
    ];
  };

in rec {
  release_7_0 = "7.0.20";

  aspnetcore_7_0 = buildAspNetCore {
    version = "7.0.20";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/7e8680cf-0baa-4957-99b7-81395b8ff60d/5a9c578ff9aaefc7ed77e63b6a90dc03/aspnetcore-runtime-7.0.20-linux-arm.tar.gz";
        hash = "sha512-6Cuw8dUtkf6mvtQZoYVhKC7Q6d425WTmQeKWyRf39l/HVVzMBG/tZ1rWe058UKcPD0joVZ/08qm7rSvGLc9qsw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ae3027ce-cadf-4510-a1aa-125958cf0432/c3d958ba80ec21e9d75ca5e8f43ec2d3/aspnetcore-runtime-7.0.20-linux-arm64.tar.gz";
        hash = "sha512-37HBvvTYJt79PZlVmaXAPhvxpkxl2YtnXWwF27c4DZgjOVPmjVP8Xr7GCtTvdUFwc/sfsyVqAXa7lk8OARYfbA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/09e67261-215a-4003-bcf8-f90d67dcd02b/b32cf12a5c10b1f74e21c8cb03880891/aspnetcore-runtime-7.0.20-linux-x64.tar.gz";
        hash = "sha512-Yu2XQ5cgQ6cuSNWqL3/fNIPPaEoysFExUATRx3jpcSv2bl56l6WlOZP6jpLa9brK8s2z6uRLuaniVTK5qA9PcA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/40131679-906c-4afd-90f0-576fbed036b1/85a0c856077ad82c29350486ebdb912d/aspnetcore-runtime-7.0.20-linux-musl-arm.tar.gz";
        hash = "sha512-yoTg7/BS1Ft/qa/Ypo8dViZBVbUHiBEF0gaWmSIFe/MyiVo8OioXAmSORnEvAiV02Trhh8j9JhD4OSkJVoq/Vg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6ef9e16e-9a83-401e-8ef5-905ef374b768/725507d68a8bc4a4297e2c82bb1d06db/aspnetcore-runtime-7.0.20-linux-musl-arm64.tar.gz";
        hash = "sha512-ZUBuFxSjEX2qNCs/0NvNXDIUMVYR6su9hYCCf2mgepSAUwMgukBpKj1tv/gy2SmhQgB58dswyj/Wem/QNRSdBA==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a3f5953c-68f8-48e1-91bb-0ca62199e6db/b3d7a2de0488fd63fa286c3fc371d68f/aspnetcore-runtime-7.0.20-linux-musl-x64.tar.gz";
        hash = "sha512-qA8xGTr3DVVujQJtOdeYY8g4mwZf4HeOe0Ng99H202UDulJzbEDnSnFsPDBQCxhYFu1g15sGrilXVLZzdKH6RQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2833b957-8fb7-45fa-bf85-4960260ae344/fa4678e8c3ceba67771b5195a2343049/aspnetcore-runtime-7.0.20-osx-arm64.tar.gz";
        hash = "sha512-feFh6kX673aT14ykS1hatz/BgyMtP40in949BdaWgY2NZAKseshs4jmgps2uj8Lq+7RF6ZRD0MekqrN4HfNb5g==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/65fff3f3-1b87-42aa-b1f9-04e7e318c1af/4bfbb002455b9a037e75791e99a18c19/aspnetcore-runtime-7.0.20-osx-x64.tar.gz";
        hash = "sha512-AGd4GUUNFNmtwrZfJbmgabwrQ/cuTbZR53/g5IMgvo63xVUncoHelo510PsZvvlg1NyycWG4xXvOB27hi7XKmA==";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    version = "7.0.20";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/06e8869b-e332-411b-aea2-7e29daae6953/6b8f60cbb630acd5d94219faa15faf6f/dotnet-runtime-7.0.20-linux-arm.tar.gz";
        hash = "sha512-okqnr+R45ir052xA5j5eXoMkqwHZrZz/MYMkXN63CGH/wRjJq9qfLy/tQjc1yieqwVvsjMX8NS8FvVtyYmWEmg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/af6e12de-a63c-449f-b35b-b72ec6ee3da5/ae129eca3d734117d14cd5965dca93a3/dotnet-runtime-7.0.20-linux-arm64.tar.gz";
        hash = "sha512-wkUSXuJwglIRmhVEVW4aqeAKoYsjA95ph32hDGwX4/JQJLdJypO1O+du4Ojkp11AP3AZuLwuUO0SePZWyy9+Bg==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2c5981ff-0f0c-47ab-bff4-0ea4919b395b/cbfdfa7f35d133b0bdef87fa3830bfa0/dotnet-runtime-7.0.20-linux-x64.tar.gz";
        hash = "sha512-h4VSlzOFVae1d9fjFOXb8sI1D4yGekic0eU1Y0utXBI6GHFGTTf8lCGDf/XUJsLq3svg9gu/P9MrwkYfR3kKQA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/7d1ca778-4415-451e-873a-dc4062d8d9a9/f38f41e5784c0832e24fe18a938ed5e5/dotnet-runtime-7.0.20-linux-musl-arm.tar.gz";
        hash = "sha512-JczDc9HEwOt0HgSMb9SDZjELNqxvBoxQ9rwBNCoABGQUToRX5+G2zPbZlUTUkUAi78uCTnVjZRe79hyUhSzddA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c30b2e10-7c18-447c-b66b-47bf12f88692/0d5fbdecc6b2cc86fd2f43ebfffd7aa2/dotnet-runtime-7.0.20-linux-musl-arm64.tar.gz";
        hash = "sha512-VSynNGf4BD01HCDXHflbqWOzLox1cG329dP85SXz798TFN8pbET77a1VdXguN2M5mKebLCP390IPgU7iSI8wog==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3297a5d6-9f41-4098-9597-c1b966c19983/46559d0d813b36264fb414562caca171/dotnet-runtime-7.0.20-linux-musl-x64.tar.gz";
        hash = "sha512-MbnaCNYzzQAo6wjDbuLFw8sb5tPF4BDIWuKRSW/l6Bi1vln11Hr/hu2TnCYPdi5X/waTSk0JVDdpNbGtx5nxvw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/50dbf5c1-942d-4fd8-b646-1f024326ec1c/5fb99e9dae294298a8131757b3ea829e/dotnet-runtime-7.0.20-osx-arm64.tar.gz";
        hash = "sha512-rxy2LinGlkjr4zTmUcJwPNXof6C7KMZwuss7PdFgiurjWuU0AsXrTti/NKvYMaCMy174Tl7HBhfZ+NmWn+e4+g==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/cbade9d9-be1e-46c0-9f90-13ba882965dc/31c86e8f4beaf0e5ad9ad35a408be7de/dotnet-runtime-7.0.20-osx-x64.tar.gz";
        hash = "sha512-rNzekvLy5DWE7lm+RH93j0oVLDCJdce9xcI3K1u9MJLrnSIzrsO4J1a6HjUqCHf/wX5MjPsgqd6Rym21TXm1kQ==";
      };
    };
  };

  sdk_7_0_4xx = buildNetSdk {
    version = "7.0.410";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4b1d565b-7a3d-4e7e-87ad-7c662ec59020/4c6cb8a150efb42f7cea7e0b4c2f61cf/dotnet-sdk-7.0.410-linux-arm.tar.gz";
        hash = "sha512-lbY5oUddm3Y31BoUwMqzmTs6K0vmPb8lH/74QEYcUdnV7NeO8JyFf+KDmRVfekBEngjHozzgiFDE4Y76q6tFrA==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3e408891-74af-4ccb-9ce8-895f6806a97d/3a589bbf6e264059544cef47be672540/dotnet-sdk-7.0.410-linux-arm64.tar.gz";
        hash = "sha512-LbajuaUy0vWaK0WeY0IGkTqVhcgh8/V4pCHjuuNGqS3ZuFt26940PKMFcnX37E0LynHLt/K6223NtRYkToTaRg==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0ddc1522-2361-4394-97e9-52318bf51951/c5aef30601a86810f1f8ea89d42c26a0/dotnet-sdk-7.0.410-linux-x64.tar.gz";
        hash = "sha512-ILjgKXkyjkxKFEk/d5HtQZqr0BdSM9uAzWDiwAS4KbPoMBKB6oaye6gYNyRzrM9abVU+U1TFSRfI6E0l9YVcqg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/fb542b02-38a4-4564-bc66-d7822758cf1c/d18f1e24ef1b3cdb4ef10bc641ce9a5b/dotnet-sdk-7.0.410-linux-musl-arm.tar.gz";
        hash = "sha512-x7Gc3yExJkVv5/IBcf+/XMQXcjBbR9jQbGRhKlCeiRMSZAXKjqW2T5P/TSz+op+hKGcdQO8jrWadi0coIjjfwQ==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/7e1f9446-53ee-469e-8dde-cc307306ac61/bce850d1c118b4b6dcf9f808b22a8a54/dotnet-sdk-7.0.410-linux-musl-arm64.tar.gz";
        hash = "sha512-O+6089U2DMm8Fzm2kCj1grZqajhMlmj/EqD9ucKfktx1e3sXs9/MgeVQP5razNe56lSQ+OFinN2Y4bRZKbaS3Q==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6d16b077-939f-435d-8f2e-11813d76db6b/ba4829249b04d6c818bc175846e694b5/dotnet-sdk-7.0.410-linux-musl-x64.tar.gz";
        hash = "sha512-Y0W6gTmvQteoMwtaXhfHGz4GgGZWEAbGi/4r+1wavSiS8NkD+3rrwqU22Ee8End4DNZR+lMTMMFvowKgdstUFQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/bfba06ea-d182-4a12-8066-fd78413e6cc3/f7940d1e8d8ae641a3a3d65b6bfa1071/dotnet-sdk-7.0.410-osx-arm64.tar.gz";
        hash = "sha512-wO8ZFPKymFBEM7ypzasC3PMkQh7OOWV7ZlI/E7enFm5yZ4NnOmAvtGLz21xT9ZqJOBuRjnZY1JpXdjtDz3XO3A==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/fc8614cd-f333-4adb-815a-9bbd07e02b16/0ccf5e50cf8fa5c600716395e240aff1/dotnet-sdk-7.0.410-osx-x64.tar.gz";
        hash = "sha512-eC4VwZziCqgzNWbyPC08246Jx2Jt5jMN32cMRCbjDMhU5E/zNBV4Yirs8hD6Zt3LY6fSrWKe2Sy1WCq2cPlT0g==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk_7_0_3xx = buildNetSdk {
    version = "7.0.317";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8aacc3f6-bf06-4cb1-ba10-ea76c29bf550/7c657ce9fbaf35843a30a34a7ba0e3c9/dotnet-sdk-7.0.317-linux-arm.tar.gz";
        hash = "sha512-S1DHTRWHGrRc9/0Bb6BR8Dg/AJX5G07ycQUCgY4vn2kCO00A1YTvd9gYeujpWo0pI7PQPr4qP/cKkQntEvdI/w==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e08e38c2-46b5-45ba-b318-6b0949b3cc2b/1780549adba82e521439b7a0511229ef/dotnet-sdk-7.0.317-linux-arm64.tar.gz";
        hash = "sha512-Irrc2yy6Dxvtsfy9yZJppmoBojIZPgC0KCOAbO5dRhlLjdAIpT4XRVBypBD3e9NRZ281FnC+lsE1ctjjDPrRgA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3207f51e-26ad-4d43-9249-5e03e93e5895/af409554ce918557a05f8e8102f199ea/dotnet-sdk-7.0.317-linux-x64.tar.gz";
        hash = "sha512-kG7L+jGxCuXiqLpxPRE8zYPjqbnk0+MiSCaSiRVClZ52xR213Tgl+0os8elRc3AGqZvnKQ8wnWgiVn06Uzp6ng==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6e895738-571a-4d6f-8519-0d64ad4a95d2/75c8734c8f3dee31dca0591f7634b4f8/dotnet-sdk-7.0.317-linux-musl-arm.tar.gz";
        hash = "sha512-fKoRN8pHJHGrlZ3s634+KCigjbX7Dhxrlz8kcKHLbIv60zLMrDH2bhGYLkc6/4KAmzX6XANkF4J66DcTe+NPOQ==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2df5854b-e405-4191-a794-8c24ddb9b95b/b0c9ac55d4f324aa81bb5918e115347c/dotnet-sdk-7.0.317-linux-musl-arm64.tar.gz";
        hash = "sha512-7US11MyzefQoaSLiJtGC5eubwS9M7bYALwbleUt5XT6/GajlqOmQxFfff566mUe8HHIQr2qN/yxnItZMnmHwQA==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/9141d472-8ae1-46aa-8218-190017c16ed6/7877e0accaa6b6800570f7b46a831c97/dotnet-sdk-7.0.317-linux-musl-x64.tar.gz";
        hash = "sha512-Wn1fIXAQs1QfqdC9tD12lJaFW54RQ4TPZ4jtR3G4NUZqsYeMU3nIkUk7VLh8FHB3j1CTHFpsiZr2E0gZO7lj1A==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/697b6485-989f-48d7-86ac-320529a85b35/5b5ed55e7e4e2c0a1ba2c3e0cceefe95/dotnet-sdk-7.0.317-osx-arm64.tar.gz";
        hash = "sha512-tfNn4eINco1xZ8geQUY1jnYPE2ue4PxBDYE8FDZuOLCaBpAxqoym2N9DhDW2q04umJvjCeCXFpRZNl1L76+fWg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c03db249-372d-404f-8767-dc7e4a104ade/49d2336dc14b70dc937d8f91716e4fba/dotnet-sdk-7.0.317-osx-x64.tar.gz";
        hash = "sha512-09vQ/ny8YjiPFQrbpdgYq+45hoY9dXzmMIj0/qv4AQUsCKYIrNUDb5cZFDX+mSJKyxLHNlvn933vKFU6IxrDyQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk_7_0_1xx = buildNetSdk {
    version = "7.0.120";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3ab51fcf-7641-4e33-aa59-53b394ae1e2e/79905a3a4708000a7a50da44a7256ad7/dotnet-sdk-7.0.120-linux-arm.tar.gz";
        hash = "sha512-epZI3jwx+NElfZiYL0rivTusMkQLz8uAQCdShZkJNK7ocZASoso/VkZUblZtKWP2O/idGbVordxNMkzpdOpLxw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/17a7bef9-4696-4b93-a3cb-f4bb9aaf2985/3e19b62d05b8e85b0a46d5dfd99196a5/dotnet-sdk-7.0.120-linux-arm64.tar.gz";
        hash = "sha512-9TD3lK/jw7m9h7jtUJoaE7HI/m8rxubM4+jNa1YyfA/yf8E4EiwtrWh3DMUBVzfgB+9XBlmcGJ7wzHUhy/C2VA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8b678e05-b3c7-43ae-a31a-c007a901d939/934ec0853faa6404aa924c99e019f788/dotnet-sdk-7.0.120-linux-x64.tar.gz";
        hash = "sha512-y5+rqDqydsk17zWzHwFspGF/DZZ8W0vx6ZPCFZmS+1nR3SXc4JkokVuf9Ybq16z5LsHdlpN8kzF6mcoMkrYWyQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/202eccdf-4461-42ed-a260-0061216380b1/076bff1764888073337b16ed57dbdbec/dotnet-sdk-7.0.120-linux-musl-arm.tar.gz";
        hash = "sha512-HNomb4ipUPRUT9/M8ezCaBa3XCn0hmv9mFiSkJQtmCp0zhfy9QfGKAsPM3t0OprQHlOjwQAcdHe91K3VO7BhXw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/69b2b43d-6e1b-46c8-96b1-6f2e8871dd26/0405b62c3762de24e55635674a37f038/dotnet-sdk-7.0.120-linux-musl-arm64.tar.gz";
        hash = "sha512-XTEkw9rx7RzvDIOOdTY3rx5SAws2Ywu/p9uhdqfsok/p5cTfnv8hcPqWz2PgBV30LwlQs7WQDesoJZDkthLz+w==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0aafc9ee-0ca2-484e-b1ce-5f40458d49ed/06cf3c6a1515f931527e8fd6986e3982/dotnet-sdk-7.0.120-linux-musl-x64.tar.gz";
        hash = "sha512-xQirUxDXQ/V+p4YR/+NUJo/og+fGc+6Ajaqm3eMLpFTV1w+BkcSetSrkqAwGLtZJC6HWt1L8xUGw63g19O7ofw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3d081107-64cb-46ef-ab37-41560d585efb/5aa6a70b37790bbea98d7b8c380eacaa/dotnet-sdk-7.0.120-osx-arm64.tar.gz";
        hash = "sha512-3AaAHY3jTfaY+T46qHLVcTHdPjOsT3zdvJYiORHg/zL9zqeDMtp74AEzYskM0k2y2GweJ1KXvm3RYpSPK9OMvA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b1da5ec0-e336-4716-b9ff-77f8160e7878/5c40db0a17dc493eb0be8d047d0c6885/dotnet-sdk-7.0.120-osx-x64.tar.gz";
        hash = "sha512-lN65mIUJ/L//w1cRTQ9WRfxrb2FWZkBAzVZDoZG+8Qri+6QWiqaJ/32hobb6d5605Tp3p4R77Ot/C6RR0sINVw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk_7_0 = sdk_7_0_4xx;
}
