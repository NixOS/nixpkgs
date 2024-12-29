{ buildAspNetCore, buildNetRuntime, buildNetSdk, fetchNupkg }:

# v8.0 (active)

let
  commonPackages = [
    (fetchNupkg { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.10"; hash = "sha256-qr83tlgz2OZRkz8f8uquUeZbQpB8WAGd5o+XYl36giY="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.10"; hash = "sha256-IKp5I4FIEGQ5+Xsjc48EG63eHAIraQWUcJcvf5vIeIE="; })
    (fetchNupkg { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.10"; hash = "sha256-DloETXESPFWqSvOdmAOFnKCq+veTqhdltiYj87Euhr4="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.10"; hash = "sha256-2co1p+5boK5rAuf9AET29KV+kTv9zhHc6PSoamkHZRA="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.10"; hash = "sha256-HFlAWYmT55k/Y+QxnueMGptQDgkuFdQtrmWL1lCVviE="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.10"; hash = "sha256-29PVFF5yeT0svgK2xWVG23xOrRSDCFJK+wVZGZHtY7c="; })
    (fetchNupkg { pname = "Microsoft.DotNet.ILCompiler"; version = "8.0.10"; hash = "sha256-vSt23zRo8oVhOv91+Eo743yMB5ng+X7iKkr+NW4EfMc="; })
    (fetchNupkg { pname = "Microsoft.NET.ILLink.Tasks"; version = "8.0.10"; hash = "sha256-QIiMkIBvrdaep+lvBn4YiB6h63FbSVi7UmDz32nLZ+E="; })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "8.0.10"; hash = "sha256-PAHPeo+P+orHurd4JstFAFnC61j4uwq2eE4c1nQmh+w="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "8.0.10"; hash = "sha256-ssF6ALeeAGnvYFd5kFTuJoxLwtV8lk5u6LlnXMbJ59U="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.10"; hash = "sha256-ufgpQqiZuvToDX8hMnZ7KSZPiVJKRuHzOo/uVtwWQpQ="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "8.0.10"; hash = "sha256-EBtD7t30cZibJ4VDdZET1ASVU2yp9FYMDNUsgaJoLGw="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.10"; hash = "sha256-dUr7mwCg93f+Oc54hzUzxGxv8J5TR4dCVhsYBfLn6KY="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "8.0.10"; hash = "sha256-rtKhU2VHqLi7cHJVb6Miw0BJNcabrHNve4fjpsIQe5E="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "8.0.10"; hash = "sha256-1wIIAc/Bp4YnWSXxI9/1UT/Iz8mW/OQSgGKCEen7SD4="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.10"; hash = "sha256-DYMtF8/2qOg+XrfPSWJ1RB623Wn8Bjp3cuaqT5iQiZI="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "8.0.10"; hash = "sha256-zcfmtvbRzfrzM/fc7aPWHUhLGetn8u3G9LXTBNGy55I="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.10"; hash = "sha256-GIwrkh6iD0c+cLdcYhJJHAXhBhA7ZWXs4/MmWWnaHOY="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "8.0.10"; hash = "sha256-okqfX5kWkn+fYSqx/lNhvxkGeTmgjlvrXMVDpuF+/y0="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.10"; hash = "sha256-5U/C3N47whMMmfBAD8hyM3ZBs2ZxFqaKhobXWLkRXgs="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "8.0.10"; hash = "sha256-8+LQHhzQvobpEOVLDC8ySv/qhzC1uf0jk6nj8ioMWnc="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.10"; hash = "sha256-NZVCCKfPG3LBGYVGTk23fvSqXk8AOq8J9f4caTvRulg="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-arm64"; version = "8.0.10"; hash = "sha256-CZL295MOXANUs9tgO9Kul2m46zfr/EcrJWXep74w8PE="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.10"; hash = "sha256-yrvkrtY6qrs+2a6FghTL2uQgf6L2o3oh/WG9KWcwgog="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x64"; version = "8.0.10"; hash = "sha256-ccqaKMg/PMKHZ2kjqOrM4wIh8V/R1cYyPnWYYa9jR+w="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.10"; hash = "sha256-HqFgB9cr0v3WstnK+wNjdVZerbQbfufzKA9NsHdIrWw="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x86"; version = "8.0.10"; hash = "sha256-jenosV/Wf8K2SiLsp4rzIu7/c2A3s+jydkmwCZ+jj44="; })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.10"; hash = "sha256-/s3SAZgRROQSOBYAAKgZwhj/FJXN3+RG5VPDbn663QA="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.10"; hash = "sha256-aVWKeHvQ4zS5bXZAoUqjefBp4TYwxW6vap5XvklN7uc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.10"; hash = "sha256-Eg/hxnHtIiJ8Zcne4x4KI0xzpmxlK+1Xm2WtrZZXWjg="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.10"; hash = "sha256-xfTjxK8Oojq87vappJZkQDWvt406M8LjqrWmzdb7SQQ="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.10"; hash = "sha256-qNdDGfs2NBc22FcSI/jut1QPCaRn//vEZbl3+YieO2Q="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.10"; hash = "sha256-juf2Zbtxh2JqAXB7GYa5HBJxcUrzXQrtK16ZfszEJ4A="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.10"; hash = "sha256-SRtJaf4VwCLFM1NICesfSgrxYYYVEXK3bCse0QJ0yW8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.10"; hash = "sha256-X4vSzi9KUcNracYG7VtEGBuLfI0UBljMjypxqQBFFfw="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.10"; hash = "sha256-uiplc7OczySA2Ni9Tnmi17FOYHp/U57qH0ou7Pc2OzI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.10"; hash = "sha256-VFIH/EWE2TW+akirg+IpaISG289PP0tl5Ur8+sGFj8I="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.10"; hash = "sha256-EhepWr2Mk/nPAtE+J++1MHQkbu5n9xewHwroSWlcr/Y="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.10"; hash = "sha256-eLxtO3uYgCYryuidL2O2fG8egh+np0HTb3bJ/rKs14Q="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.10"; hash = "sha256-oQ7p6X/5NVdVw7U4wbnNy4xK+dZNvPbXWFjA4UuPGzo="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.10"; hash = "sha256-2l0Q+H02bzRG0NBStTaVOKLeZ4CNjWCj07cjkgOugIs="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.10"; hash = "sha256-EmYjZ/h+hH0NLe4estuua0Yh33yoIMHNosVuyTNQDaY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.10"; hash = "sha256-yyTxpyvp6NWMODvZ0wVZRAWVzCgODFvBBnWrGawP7+8="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.10"; hash = "sha256-8noK1Ws4w7JCCH5NGT9DYNqKUIE/89omwoJJaT31DvE="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.10"; hash = "sha256-NUzt/9eU3UV1iw8hggRTDV1po5Xtq9ooEZ5inJ0TRp8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.10"; hash = "sha256-lYyvJWF0qVxM1u/rpXMpAuekwQX8+ATX4H0B1VYKPu8="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.10"; hash = "sha256-Yp9WQ3kQzP5AFc+luQ3t+6x3nbpnSBmSeXaQUda2+jM="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.10"; hash = "sha256-H6CfsMpTtenNySVdYFt27DJqM+89paFp6V7PK91XDqA="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.10"; hash = "sha256-RUTadf5Nxvt0McVm/z29y3LQNGvakR0DGAXvQISk/F4="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.10"; hash = "sha256-CSp3a8I3EbjXozgWQGl2nzn1o4TdbgZeQ6d5A/ipOVg="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.10"; hash = "sha256-t0vB9HOaB5CLKvRST1QeKlpgEG6nvX+qRkEvAZffUFY="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.10"; hash = "sha256-wDwLqu16ILj4q1eu+/tMZR3D0CuX7zeoPZe233hg7Vc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.10"; hash = "sha256-n3fx5GHZrP0PTb8UMusgZe1nHkrsi6Vk7iY+NqRJ4Ss="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.10"; hash = "sha256-l3yE6YMFKts1bBxbJUILpd2g4I75MWAgqeW2TMMgNzs="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.10"; hash = "sha256-yxkx7C3R64TDYbsgVGPoM+8BFD8PS41/MHmOZiJJhwc="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.10"; hash = "sha256-yqOvz/0ZgF6pWzg6gtiHGPfm3GKfMwAaqJGfd+K+0ng="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.10"; hash = "sha256-EGK0d5m88xBScyeohJOsfNeiaK4Iis94TkqPHoBDOrI="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.10"; hash = "sha256-iACw3MvgxtdoHeLF+sBPJVbRYDlFj/ixTeaNw5qXGR4="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.10"; hash = "sha256-trm/1LZPN4BDr1SvQmacTGVZDQLVKuVH0w7GJ84FQVg="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.10"; hash = "sha256-e+o0ec/E4I4blmj1ltcovIXqK6GCEwV5CMblUZuD2/8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.10"; hash = "sha256-OhXUVHm0WABY9w9oTX6rCNI5iQhJcqzhwS7V2HIsWp4="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.10"; hash = "sha256-IzTftfK+vS8ZBo//8XPxDMUbvNirBaQSz21q3jNAvag="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.10"; hash = "sha256-XRTCbG+e85AGYcv8wDvL2NmrRwHUPb4xgjKWwmOhVyw="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.10"; hash = "sha256-9kP2XFjP+som53HTV97vTEmqyZLN+KIVj+RzcaPKcI0="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.10"; hash = "sha256-k3XtnZPIHDWE6bZX0IDVOJ3MMhBcd/y3Wq0Qkeqm7bU="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.10"; hash = "sha256-HUrye7hNJsLS36Vh/dDiQDn1oUtoNcTWwulersn2k/c="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.10"; hash = "sha256-Jqxj6tDq1DadZk4tMNQo8RpLNhmlFlN0kBFY9VRJmb0="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.10"; hash = "sha256-JnHGicqJ2Na95KyJkX+UAM0uDmAhkqmVIhktMg49aWU="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.10"; hash = "sha256-Itqy8JDjPpXH5U1wLl6gj80b65zI8tQYAe+AEzgxtZE="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.10"; hash = "sha256-OSDH9d9EASV/kswQjlEIu6kaQlfRMpT91TPJDkPlb4Q="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.10"; hash = "sha256-GdPlVPjzC0scVledxgs24kFZSHujYyq2UHDAzLgt/eE="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.10"; hash = "sha256-I3jZdK86aqDnxz2xvcp8oGJurpmaPckuJR0TG3OxOOc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.10"; hash = "sha256-QQ+B9S/q35MsxikeP43OQ8J5mghq5f+xdPHaNdBMeCc="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.10"; hash = "sha256-GL7OjLalZPKLsoheVJAmVStJFpJ7zTDJtikCP7fB3jU="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.10"; hash = "sha256-IZ59kjeU/mGHBVXtOO5AFK0ocxwFAkFqwtn99N+l0zw="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.10"; hash = "sha256-0fH2KlzVL5ydblrVtBtAoHa5kNYY92Wzv8FCVqav3Mw="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.10"; hash = "sha256-XTWvKlTEEi6lrBZcJawPrxj2bjmsWVFGphjCxpSIBLM="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.10"; hash = "sha256-C+u78GUiX6VzkoOYuqiTy8DvHUsJzWR+apJu8ZU/tWI="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.10"; hash = "sha256-DVxeH8nfflyG+pCdft8MfDfEBCD/7dXTwlOz0aGnH8A="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.10"; hash = "sha256-p9KjfiNnhtqTCl2aQlYq/UmPsyqx2+mddTA8nbh2xnk="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.10"; hash = "sha256-d7Gb+lPHI7xmMwhsTQzWJBq42QUsSRRU9BWZxmdXKWo="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.10"; hash = "sha256-u6/4q54irXtyKSSi1bH6HYrvcod7yfs5YdYD0NXeYbs="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.10"; hash = "sha256-B4aqUvMpyewAwquTRVh+bs2RG875ZsveYQU89+4VFxw="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.10"; hash = "sha256-XKUQ0DDWWbZNtgGPKhdI7ufpd9Ki1EcOcK9ojiaWEVM="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.10"; hash = "sha256-Gl5S9T53P3xZj5eRwPe26SnMlPboQHB4lxTw1nIB2Ac="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.10"; hash = "sha256-vmGaHkqKQC4WA9Kl26ZpQv4H8YIJblk15RayYATG1JA="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.10"; hash = "sha256-MFSnCAiE9A6EvhUQff4g/6Js/sxORln2lhW74NTeQ34="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.10"; hash = "sha256-lYNFKHvU3RZVzwqkGzxPem5LHfijEFnO4OcGGn5BUMg="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.10"; hash = "sha256-7RRH1rAdGFkdB/FNrQTDgBywr1tYc1Rezo8LXRSZ70A="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.10"; hash = "sha256-OdRFIExBixFh1xwOtEA94xedmHVGPXvPopF9Lbf3ec0="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.10"; hash = "sha256-pmsaof0XFXZQmn+s5nijm820TSdQaFlH/EpGy4OqMhA="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.10"; hash = "sha256-xbgfV4a1gtH6gzoXSe7njaDEvvx3L+zVfLhfF4705r8="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.10"; hash = "sha256-1H/t2OQMWfypSe1g6jWITx3klMD+QgUAj5iApzL2vTY="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.10"; hash = "sha256-HmWsVmYVtNxX4xbQ3Mbra2vo0kjvMGXEQ+zbcTAAmsY="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.10"; hash = "sha256-rHlT/ZFXIVkgo1QgJh+h0OJ6gnizyuqAaBczb7Z1NOU="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.10"; hash = "sha256-d+ILcAY9ZvXx2klfv6zxASRq76htI4k9eTO+Ctq6+DE="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.10"; hash = "sha256-MrEAlX9Ep1w6fnXM1H5PehDbVXj6HrSSBE8ka5+zr4w="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.10"; hash = "sha256-bLWBI3G4+TrV5cyaaKbuk0RSh7Q6lYI5msZd8QXi7so="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.10"; hash = "sha256-B6o1+6o3Cih7cmgo2ClwBkIYcDA7NGZ6JClaHRDJ/B8="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.10"; hash = "sha256-TJtsPhmyiE6XAX6WmSASd7vcRQwREJYd76CKGzCt3c4="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.10"; hash = "sha256-59D1z/LeAqw09/SsJegUQWQ702r5wsmp7O87iDZz788="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.10"; hash = "sha256-OCDkL6JuPoxle/clIRlg8A2/COUIuzqeq7cSYzNWcmQ="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.10"; hash = "sha256-ld/Tu7HAiAGZg6+RYMO4hpg3NKs3dX8XlSHPsLLygrs="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.10"; hash = "sha256-3nn0MR1m1P1usLy0JCtiCjon3w0xdl2MyEJaHbILmW0="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.10"; hash = "sha256-O7gy7qe+EQsU/i9LVpNFjs2RjrLppQFatD+u9W8Wgo4="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.10"; hash = "sha256-oA9gg0LDJrjGx69md9bWUfQy2ED3OVhhMMmAw26L2mg="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.10"; hash = "sha256-02ueHHg0U7yEvkLV4gdxXg2XIDSJ0LBCt5gNcrsy3O4="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.10"; hash = "sha256-M4LLVUaJpyHWzSqYsXMzB4OgxlzHf4Pp79XwNgnO6DQ="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.10"; hash = "sha256-yRaUcqgJr+XHo70nWJUxX4yJwavaiN3pBKE+Ov8bFTs="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.10"; hash = "sha256-ZJN/v/J1b/89BquCxWHZlnfbsQn8N3756HPQ3Z8Zv0g="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.10"; hash = "sha256-4mNR0mls8jqyh4Lu+Wv/HykJOlwLlX0ceyR4arrnNe4="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.10"; hash = "sha256-KUdzJDhpW9xj5xSH4zovpwZb7I3zcTKXa2PFRlBlOzs="; })
    ];
  };

in rec {
  release_8_0 = "8.0.10";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.10";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/50a67fd4-a5dd-42f1-a3ac-e008c3115dcc/816972da008ae5cee7612cad9b6808f0/aspnetcore-runtime-8.0.10-linux-arm.tar.gz";
        hash = "sha512-+ui2snCk3JIY35m7PMEPClLbntNjC6ggVkAhVNJ8I4925EVh+FNIzxpPfivR29kQ1BOKke9mq+VoXZlys9BQqg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f93af34d-cde3-4231-a54f-119c328bd876/663b3c2dbf1ed2a3e08ac8e614060571/aspnetcore-runtime-8.0.10-linux-arm64.tar.gz";
        hash = "sha512-OkePkxDHSLdCfJHes7qD9MAlV6fXo9c4JSa23Dna09k4AiR1qyDwYPG07TZcexuVodCJzKUCpCMpjEE3m/+BEQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6d143cf6-e215-428e-bcde-9fd50ea0e1be/99652e31b3e0161a3f1f933e0bedf223/aspnetcore-runtime-8.0.10-linux-x64.tar.gz";
        hash = "sha512-MyIfGZZMywbLp0Qg2sv+W/0Db3hHOHCTEZ+POR1XFuHFqOBXIfIzWYRAm0NCPXm1HsVx5R8M365tnSorLZhQWg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ccbec918-1f15-4f1e-ad7e-b4d1a679fa91/f8fc5b5f2fccf1fbdf164132da8fbda6/aspnetcore-runtime-8.0.10-linux-musl-arm.tar.gz";
        hash = "sha512-RbGzEQzSxmhMMSCnGdemLXpqwVR0EB5in0fOASq+HGWqZ7k/sKBRKLdGL+PwPtxcukD8eIAE+Iio47J8hh7sVg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c150b15d-79f6-4343-8aad-7748ad4765de/0e0768e8874957a8b37415919d77a9e1/aspnetcore-runtime-8.0.10-linux-musl-arm64.tar.gz";
        hash = "sha512-xx6iRxYGYJa0i+XOi5/ToUT/hlg4L3sZPJw4jq20J5tkSyvHoCk8AaYQhDmdXonIlS+T3tkL6qxqAcNhxXqP4Q==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/fd29b6fd-e351-4758-8c61-0d9c0a6813d9/8be59cf5b2537298eb59d44e472c6b4b/aspnetcore-runtime-8.0.10-linux-musl-x64.tar.gz";
        hash = "sha512-hK8Vb9YUX8aZxzhl6hKlmU5D54iUX+3NXIDZE2uUgq0NngvduTP19y/x3PuQ0G3C6Uoh0C7aELwQFfPkuGOdFA==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/05bfc51d-d738-4796-ad78-6f16dadd2382/9a64a66f30708e38b6470a480ecc850c/aspnetcore-runtime-8.0.10-osx-arm64.tar.gz";
        hash = "sha512-K8kXmEOTIij7NVDNPu6IpkXFttaVpWFWQZXwtFg/wMkHFiVN3pJQIL3aA9DgGB8El1DAb4OYoht/0O9bjB/lhA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/135424ff-12b7-4b4b-83e0-1d04b053ef5e/9274109d1ec702677474c148ad2af1ff/aspnetcore-runtime-8.0.10-osx-x64.tar.gz";
        hash = "sha512-euH0JLv/pSuB5duPHVkNZ8NKiGUOtXPQXJIiu7dP+J5v8FgbbOJnVY8Z/jQzRz1KhRO+9PXhiAzeA/GWBrDULQ==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.10";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3f8dea7e-13bf-4931-b11e-77fcc6de7ca9/37531adc6a054037c064c47dae4e7f77/dotnet-runtime-8.0.10-linux-arm.tar.gz";
        hash = "sha512-8GuHh+T4b2FWmVkiiprn0Qu3ofqWcBDX88oAgMhQUTz1ZXwY1HIhHOFogP9er8bIRCpWSy+DUdd8XdJwITyYTA==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6c71a005-d902-4df5-8cbb-f1fd53cf14f7/658dd2a2a839c14173e3804befec6a7e/dotnet-runtime-8.0.10-linux-arm64.tar.gz";
        hash = "sha512-MVmf+8pxAkf04D/pmxCYsoeg7YIKlEtabtIjcmUcl9Z1McNKutvFLlno9wtPds0zEiHQCGhPP+79m+KQSnPjiA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ebc433c4-8f01-43c8-a1e2-bbe1291ba857/e073f3f679d7a4067a56e8f5d12fc0e5/dotnet-runtime-8.0.10-linux-x64.tar.gz";
        hash = "sha512-f7gTZ3cg0SXCM3/txhMbIw2vHB151ZEqHKa14Iv3gCtBLeMkjWRbZIOrI/P66DftAqDlIOMwIM/vLIiMVPR0rA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a254fc53-e78b-4039-91ca-38fb3e42535e/be0d765e74b082a5919248c97866c7cd/dotnet-runtime-8.0.10-linux-musl-arm.tar.gz";
        hash = "sha512-rsjIIFkaE9F9gKFogPpiKWHqOpgtXqMLJuqRXtjYYOlQCyrHruB6rMCj9QXqM6ZlA3CWo9vJ7ZX8zzNeS0udqw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/aa047a4f-73b1-4a00-bb94-1fdf28bdf606/533876a5403795f02d8071d6fc9be4d6/dotnet-runtime-8.0.10-linux-musl-arm64.tar.gz";
        hash = "sha512-Huyv4nKgce14vJG0yQCrcOwQLJ+Cztz94nm9mSGn50DunogVOKAKbOQA2dwOvJMF6M1JYtskMec7aR4QUmlOwQ==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/abd532e1-6dae-443d-a35c-fdbd5053e239/1ab2cb2acddcbd435cb6970721f0f85a/dotnet-runtime-8.0.10-linux-musl-x64.tar.gz";
        hash = "sha512-LW7cwUudn++TrHL7MrF6Yxjyr1vdg8SzSzXFkdzUBtpNSJwaTVgIphusLuFLQLtrDo/+m0JJAbcP4tlp3v+ghw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5fcb418a-d290-4fd9-bba3-d0ebe56eab58/e20afef70b5f56e36daf054ee3e09d82/dotnet-runtime-8.0.10-osx-arm64.tar.gz";
        hash = "sha512-10aWjQSUf0qH0k+/RxMJoDd/mQoYd+km1uUbUCIQQ6snDABRf1eKpT1lPhiszDhvVVGp9KzTawIz+2Y8NTOtLg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c71dbec0-22de-4f32-aa1f-8e7112fa380a/54b3ec6159d2f72c813d913afaebcf2f/dotnet-runtime-8.0.10-osx-x64.tar.gz";
        hash = "sha512-RKvEd79+tA4UHXFfiVw8WwkUgYVHNt3lNHqZcxkdy188P5bdk2DighSfHZejPXwIuTgAil7fO1xI47k9s1FxBw==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.403";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/382e3bc7-f055-48b9-965b-89b070c15713/54b2af6b1ef970f852c29a850661728b/dotnet-sdk-8.0.403-linux-arm.tar.gz";
        hash = "sha512-3cwikxZHW6c8xGUY6iY6l71X+nhGpP5277kPh0MR6Kf1cYrG3LhhaDW0Mhr0bw4CZa5IsQblrcm6gszojoBKSw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/853490db-6fd3-4c17-ad8e-9dbb61261252/3d36d7d5b861bbb219aa1a66af6e6fd2/dotnet-sdk-8.0.403-linux-arm64.tar.gz";
        hash = "sha512-9C4bqaiX+RyNc0sJqb/IJCjwYpt83ZN1JiFY2fKCeXwZlVjDeufzaUflfYrcYa+UkFlcTmu9BSF/1tBRM93tTQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ca6cd525-677e-4d3a-b66c-11348a6f920a/ec395f498f89d0ca4d67d903892af82d/dotnet-sdk-8.0.403-linux-x64.tar.gz";
        hash = "sha512-eqA2eCKLF09RxFNfGDSM33pdNeJDsfjLKKSjDkAuR1Z9Bt9jyPbaS9w8fomPVPSswI2ZUr+knT8iDQNTJTrD6Q==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8c87dbf9-f000-41f4-bb78-3aea9eceb73c/d75a2445ca5e49bb07243f047c602013/dotnet-sdk-8.0.403-linux-musl-arm.tar.gz";
        hash = "sha512-a8XsagruodiwAq8e32PaD9yj1U0s605RqQ6lOpp1hWHRYeT6EKw+68Vku9QAwblN8uBMJrrgHZm7wQnk7uMjZQ==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/18e32a84-60ec-4d82-8ab1-84511be4172b/4a1e6bdd4f15e0d55e0d9bb20c67631e/dotnet-sdk-8.0.403-linux-musl-arm64.tar.gz";
        hash = "sha512-u2POAascZLhr2U2QwQ5WhocnYnWlz5FvaE/l8TFyN0UhZjnjfTzPK3kj9VjxkN04SP9iH7yOnspbSVG1t1uhEA==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/662d63c4-fb9e-494f-96a6-e5d564dbb488/b39e35ac3115e6c8b0c1333d8327d7c8/dotnet-sdk-8.0.403-linux-musl-x64.tar.gz";
        hash = "sha512-kgNzMgsHaVRhgPUJn9ujNDg7RRAxIPxa34dlg5huw6VxToL81kdUed9BXzMtzk0KmJwF2uH00aUNAmW5Eh+NLw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0f1c8c1a-a14d-451e-8a14-4088b0d29cf0/37d7a2637468a506214ce484985fe040/dotnet-sdk-8.0.403-osx-arm64.tar.gz";
        hash = "sha512-89r8w54THem///GQrswI2HqgYlpmJFr1XAGbXLZNFZPNq/ZSwZfOQVK718VM9ownNJnZaaNIheO33wiQv1yTNg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8d0cf513-65cf-4691-a436-7363a5c10af7/ea63a46f9c1f901cec977f2c88538146/dotnet-sdk-8.0.403-osx-x64.tar.gz";
        hash = "sha512-Px9csJDUYaAmUF/8XR/ObxW6U1SzAiVMB37rl88jyDUDtFTi+BJfvdNkf00686GkNngNKihC1csJ0HarXkAURg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk_8_0_3xx = buildNetSdk {
    version = "8.0.306";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4bbd0de3-6535-4f95-9b21-e0ca491bf9e3/9fb72861024e7ba9d6a35292cbc0e06c/dotnet-sdk-8.0.306-linux-arm.tar.gz";
        hash = "sha512-3fTLvDPhTqU0n9DRNy82uOMpIL7INiXa0YeH5xf2FNlKn9ntpC4LP75o/9vHnTQ/Nww0EsagvEdQqIw+XF3wpw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ef4ce459-c628-43c8-86af-353d9d7e7c44/804deed3b6ec5a3312867f62e6cda7f4/dotnet-sdk-8.0.306-linux-arm64.tar.gz";
        hash = "sha512-OlVLkjULbn09hu2SlJKV1GmWNZRhgkDJiBrbNvzK+4pRpZYahQVvMvC7V0O23c/YjnOTWeDKzGniAnfHR8K+Kw==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/29fd0b9f-1b65-41ee-8d3b-9621c99ffa68/67a5a0c8846c41bfb5521c1df3915bd8/dotnet-sdk-8.0.306-linux-x64.tar.gz";
        hash = "sha512-tZZTUIp/G3/1Y8M9ItkufnHV/qLwHWAEKd8+8mL9rfEdEcwlH8s0lxWuhv4Os/jzUiPw+E1w3S/hw5o/CfbgIQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/45e213b3-e64a-4425-8022-12551182f8d7/7440e33fddc3b065de3ec91c25dc1169/dotnet-sdk-8.0.306-linux-musl-arm.tar.gz";
        hash = "sha512-JtkK+U9PC0AXRiHatloxTBxlgSNlDV5ypD/9rNxdHocYGo7OHNDuZwrmkLZRzWiUdW/RqzzxMxfeVddhkK+vEA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5ecf5f2d-d4a3-4e2d-a78e-9d0d02352473/b1167527b6911875ef8b4ae1734c6fd3/dotnet-sdk-8.0.306-linux-musl-arm64.tar.gz";
        hash = "sha512-Ce0bWlt6EDoFg1O+EHEhK16ZWI2fiEHWeRSsO/c1b3zWGn2qnU+JmMlBCARiVxe4Cgw2eygNxBubelwTJRnV9A==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5b32ef16-9c52-45e7-b713-afede9fad881/f15872dc2cc9df4d85b4b8d34f94d559/dotnet-sdk-8.0.306-linux-musl-x64.tar.gz";
        hash = "sha512-dWVzSibY7znXyOrylnYoyeDkyr3CJTkKhOKI4zXNLjZ67zxivkLybqP3cA+T12wFyulXyqjY96yOKsSl0SfT6Q==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5750e793-89c6-419a-9d06-cb4f85dc5884/de1bdcda0b0a5b42ce1e82e8011d97ac/dotnet-sdk-8.0.306-osx-arm64.tar.gz";
        hash = "sha512-MGq/ju8/FtiJlW8YQzsKcdnf7sw8Bj5ODTP9/jfU8tEQbCfMxElhqeLgWIOCwz0SGSuXNGIeqk7a5o561BWRpQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c5d29ba1-2952-4da3-8eb0-9eb0aad0a857/8535d896d90cf0e02244a20ad895290e/dotnet-sdk-8.0.306-osx-x64.tar.gz";
        hash = "sha512-cq9N/PmNTi7bq0hd1zeRoXucJ+ya/YekCo8KsDXKcE0MxRScNLSeKZh1/K7DCaFy2rgTYLziewm1F94CJLyuAg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.110";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/090357d3-4a98-4737-af12-95cd0f7c51d9/d3c813f556a47c6e302767b8ee1d2915/dotnet-sdk-8.0.110-linux-arm.tar.gz";
        hash = "sha512-QP5sEu4/Vim45hUFIGVPmVqg7pgxXeFiN0IDDhaLFiJyGtZA0m9Ev8EfIZO3r6D4vcu5U81Be0V254rLBTu3Yw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/22fdf62f-eb78-456c-9a82-75da635a2dfc/d47faae423b4f0666944beeee63cb6b3/dotnet-sdk-8.0.110-linux-arm64.tar.gz";
        hash = "sha512-KGylYOebHHidgPtvm2qtLhBdbjk5z2djlBJ+SB6bIAvJ2nLYe7gWK2sqT2JpSjbtZsofPY7eJhp5CrtnZTfRZA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/9d4db360-5016-4be5-9783-cbf515a7d011/17e0019da97f0f57548a2d7a53edcf28/dotnet-sdk-8.0.110-linux-x64.tar.gz";
        hash = "sha512-Pcckqt3tl7rmOZafixVgGWJlSvZWGhMv1lDsagOnRzoQYfj192BstLGksSfmzb+1k1S8AlvT8HtW4Khxa0tmrA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8991cc2c-60ba-4cf9-a687-1fc9c07f459b/12e0c566b39176c4c57f080c30754964/dotnet-sdk-8.0.110-linux-musl-arm.tar.gz";
        hash = "sha512-5YzynONaW3dGYQ8u3TVVZ1GTUBuZjafZ7FKHVcuz/cTSJJ2zOGRah4DUevRvFpw3wTybrWfgDIYNM0xGoBFAeg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a06e8e00-14bf-48c6-af18-799760b12228/8765ce8c3bf2e468a640084d3c12a702/dotnet-sdk-8.0.110-linux-musl-arm64.tar.gz";
        hash = "sha512-ejcF2layS9s3tRbkJd+UT6jPMqPV4lI5z6Sq2UpxbV8QkYMK1FJ0omEEq0q3cuDc2GeaaY2vW8NLJMtygtiG4A==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/47769d7e-7c66-4887-9041-caf21b3766f7/46218edc4901dc48740c6a154ae21b83/dotnet-sdk-8.0.110-linux-musl-x64.tar.gz";
        hash = "sha512-jjgxPlsWv8ATmiK6tkx4GPm2bbn/7U5q3sINyuhhjZ3CDGy+8rwks0QLZ5Vp4d3qRLB2YeQdRd4LoZbkUm9oGA==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8d926822-6970-434e-b77f-13db037f929c/73e8ebd5b9129e903e6833c8e755b1ed/dotnet-sdk-8.0.110-osx-arm64.tar.gz";
        hash = "sha512-bWTqXAA4FLD+9LW750yvnqUCZ32iLGdrLbAbuUBTokM+qaqTIGcUWAnF2YhTpsSoB0s/JK6Ld8g1lAJwiYv8zA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3927a23c-34ce-48e5-804d-a83c9a4110f9/5e5642702e03e8572f2f772c2166d331/dotnet-sdk-8.0.110-osx-x64.tar.gz";
        hash = "sha512-xWuCfacAPfcAZiq9CPWvBr4iOHlL9O0kl41hLkW5fA2ieSv7RSOHGoCjI7stT3aJ3p0hbu8ptlEIeV3sIKdBgA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
