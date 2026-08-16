{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v10.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "10.0.10";
      hash = "sha512-zVePc2z0nthJLAU2mOvUiLaJN0cEQ7Jai1AJoRIdnewbK7CzbglrfTTtbQalzpkEPqI5iHIwRus41fUU7hSVRw==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "10.0.10";
      hash = "sha512-b/92x5JFmm04Q+ywohTzhbsWV4AfdYNi6ydGnl087/OPtYP2IF1ODOSOPpTqzHvM+kgCae6gwyGUziLs1vB+Mw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.10";
      hash = "sha512-5ia+a8kk0L39z8/VbH3zgAm0RTLmn+aBMVHq50UO80CumizZoMnSYEdHSiIVFjYTVztgCjlxPjZP4Lvqa0f+Ew==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.10";
      hash = "sha512-PHarHjlmwT/23Hyxb9BXDgFyNk4+Du4pktmWCMcdHZiuIDHqxUmBMeBETeyqGTG1d1caX+G1m07dwsyfp7xSiw==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.10";
      hash = "sha512-Ne9wklPZQTe7T49oaGGqsdkiNgMApx9BPV4+pqw2DMp0KPCvxUJ1x2NIYNKjUJjdpAQIdV4HuOUJlNqyh4nNfA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.10";
      hash = "sha512-gE8O7DrRAI3Qir3ySzvdRl7DzVf8XrFfI0vbUXl2GHim3dMPdVol9DxwNh/Tzq9ymok1KU+2wu2qrF5jWNv1pQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.10";
        hash = "sha512-iRtaaG+Ez8GwZ1fSgJ+/mgmKnyXGTTzz3Q9DPAEVmYLFILubcLGr2Vi+lp27nGzFOGIOoasfBAIPy0Y/VUXElw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.10";
        hash = "sha512-S/l2kyhwQAypM2P2bEm30xKsJQLZVSK7KkmvCqKYyDCeaN+13RLVRBwSe+3hS9FcQRwgIS8uUuUm15oSQntpCQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.10";
        hash = "sha512-pA4e9aTyEgg/W+9sPVaDO/zfdlkco0QSdau22PCbRF6oXcqHDwPGonrdWQAGOkYMezf8B99Lzb0qJH9IdmS//Q==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.10";
        hash = "sha512-tLPu++eOKgAyVtYw/tbBX99z5iHp0Yqd42mhvrOIkXb2yXW14Xth+EgAIYiJajwznfBO66Pwnyr+uFqZ4rSDqg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.10";
        hash = "sha512-IxKbZWV6ikBPmJpM1IBA3TAxirCayJ/83PbFqYKkAZXlsdHI74wT7/Lr73XCHeePJDa0EszXV9ckiXdeEa2lqw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.10";
        hash = "sha512-qanWBdSvyncAmXT0PCz5hgRx4Mb020/OFPv6s1+zuSdeUHpMeeWaX95/fbnq7ExgkZwDMdCCddndYSH2IZyqug==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.10";
        hash = "sha512-npll21JKlnNYPvYU5Yo5o/2XVBnZ7tZgHQ3TPLiltLBEKmC2+zpcpGAxJ1piuTQ/oH56SAPSZp2Hj1oa+CuPgw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.10";
        hash = "sha512-wVG66vbzzLe3pz3taIkWiNx5bWmR3e8iNcbXmnV/xuE19CAx7QYzauf6LOU01IQTU+HGqCl7cmWo/939Lr2+Uw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.10";
        hash = "sha512-Sm9SqEvyog0kofM1Qst0UqrGrv2iyXjmFIRR/vWOzZYTMsJ9+Q4NQXpPB00zFhbODQI01O5HA+Pi6uvzUQ8N6w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.10";
        hash = "sha512-dmoLQp+qEU9X91TngExciFF7nJUIYRIAJWicMNn35L+3gaRhfV3DP4sF+JG8MgwXDFNo5EgMqKdx53hNhPXj4g==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.10";
        hash = "sha512-vkoocTUasco6tNZxoKzm0rU8QqtHtRf5ksjpeQPaRobgwz3a/mVVA9owV8fknupHNKAsqo/clyUbQnV7iTLSoQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.10";
        hash = "sha512-M7oiYYtSsgYzHBMjuL4ROibbNy1Wkp1yYIbKosJccy219GU2Jh+5Knxldpyxi7K1fxCfxQLqE8k8OXkB5ZpfSg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.10";
        hash = "sha512-QgUpTC66r1gSB62oQ4p+71Y/46Mm9QXC1YJNHLzPb6NiylxiDPexh+bbevRwd/wF1kT5PdbsTaJcPd8mnudIlQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.10";
        hash = "sha512-le0X7trVGiaA3Q5t1MxHDI+CmVAOMD6ZdDWdmfP7SYePF1GFjXuawZuRV3GydjzFlo6us9f6fSbzfImVNKx/CQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.10";
        hash = "sha512-1GGovvuhj7tX+VuWlPWr02ADBV12FVA2wX62LHbcB+OqmZ61HoFtefK9Pb58yZaz+3KSo41qInk5MINwLINavg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.10";
        hash = "sha512-RvFVuZU9oFlKVzELlIoy6mllPPqgV91KDoJ+wOkRQ7dWdJiD91V3dWOFs6ETM9C4OzpvDXXlIQxAUgr6QYG2lg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.10";
        hash = "sha512-s5fOa/TVxy4fRToEzZe0OxKdGcIaGiM/LzjZkR6Q9dUDuBTazSOZIOScgJmx5jCp8xJiStPV6myCUQgmMLgXLQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.10";
        hash = "sha512-N9FjnPde9ztHWN82m4A1B+7Q11xpoPD7lcTp9I0Pt+fxwvyYSE06ehGo8VtyIibac8ZE7CZwqZI0COti/0n3tg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.10";
        hash = "sha512-0DiiD9WUzrIYjRpB7rgBlzToKgFzTy1bKptzRI1FpHBbwkA0qVOh20qgmwx4dJGaRFF1w0bkwkmWdDfNlvzAtA==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.10";
        hash = "sha512-o0HQ8n884wbR/Fa8S5cfC1MRQJrkqFAHEhjeqYCaXtL64pKi0PT8+DTm0WwywvNuwfyJ9egVbKcNZBfzO+mftw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.10";
        hash = "sha512-5ZZY2p+X5WxwxT8KqA4RhPflXWrjPym5wxFO3PPGbTZ9yFTaFQRA0Cq+jqTlO+ekik+M2rhbisOfXe/bza8wHA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.10";
        hash = "sha512-jPWUMWCdTx5mAkTXXim64Uq+myOEKsXjEgde3raj8F4Yp0QSA9l/Gu/c+WmNvTlcIKfAncByXIobnqtlVSZ+Eg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.10";
        hash = "sha512-zoLK2oG3K4mQbMd5wQZN/aA7WJHPB8SrU+hdaptfIVlPA1mGeSTQZ4v8Beqhjm8vhETUJHwblxnMONwc5T2mWA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.10";
        hash = "sha512-/PVJik1UzHZ85PPD7RQXZtPsNDLVzQiJqVse/HaNxWsn+358IDo/iGfT3j8x5NKPJUDBkDipqwIv8+cyUhoCqA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.10";
        hash = "sha512-aBtCKth6hLH5uSd0l5zhKXub77x/B9rQtBRR7li1s/j/4/5rBG2UusqHShGzxmcGEsvLIe2YrWHPdgVIm5kf+g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.10";
        hash = "sha512-714TBU99meQpT9JXZuvrV3H9pDK0TwGhcuMvo38IOIjPuZSGExG6JcJToReQZrODB+5+ons0fil+xnrOpCDh3w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.10";
        hash = "sha512-wvXLiOfFb1gKY6uBDbZ6xyxlmieVXJLvkmVjoxi7CHzo6LEqypq88xRYtCPX1pZvGBcOQIWHGxvQGvdaEn1oCw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.10";
        hash = "sha512-pGFBwzzPgridrYBRtlOOrhoCAeR/PX2prrcysDV7uD/3MUjKm8zYuYCe41mdocMrF7WIUeNI7rlOaaur+Nc/HQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.10";
        hash = "sha512-XNyj7pHGk2nTzTTAlMgNm3njxeOVCD7oxWh/vLlmpUoonn0y2vIubwoNdxd2D6I2SUDvRPQRsM62B2SOiIO91Q==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.10";
        hash = "sha512-Wea7/9BeqipVadzXn54xWlUvMovC7rZVuSqslythntGzwlEFcGLwl0TLm0hol7e7qE2Twjtc7xwAcIcReZgPoQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.10";
        hash = "sha512-BxNsx/yGjPQ5WMH8+RNzlTbDISoufARNzgHlu7TDu+5Jt+VUJla7umpsbyZOxjiUhFL0cwiOQY7gApMaXG1tQA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.10";
        hash = "sha512-xScwy9MuoiEMYwYQd8jG9v76xz8HIJQtxTG6knw+IJoy5mdtdKdjBO5b8z/tcSIXY0JUuMZxfbB9lX7R7gA8uA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.10";
        hash = "sha512-1DbEWmDKdgDmHtwZnbe3H5s+Ap5YtX14BZ3X0IR1SX4aZCTLnd9oQ36jlrvhkio+g/EWlAJobq+pgeC7MVjIlw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.10";
        hash = "sha512-998E9RCzaRB3KmaXKAGaZHhknfFB+Ed1ytXwPUAH2oHeQEAg9XBntPQ/xtvRzwYBU2O3uhG+ym0NwXoepfTMNA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.10";
        hash = "sha512-+BFq9VHPyIRTHviJX0noGrUi2wrxQiemNi3SgDiP+2j4Ug3hbq2LeMJaXHcz7ANVV+23zKA/77l+PXvrvNNszg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.10";
        hash = "sha512-CaQl+VztPd463BrG0nb786i65W2eRUpDLgvMIO7NJxgJfki9LIKHhLypWSI4F0QEGwLmAaZzx20dWQe9hRqTOQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.10";
        hash = "sha512-a14xk8pvZwbbUXvSHV5mmvpMwGHcDh7K5tfB7/i2MVjuHOwRB5oaNF7cp2e0v0Of3PaprWTDBrlEi+AzECsuDQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.10";
        hash = "sha512-TfN8R53DpwK4hJMYwHuv7m+gPdPBFJ6pj9pIVzMtAVj+elJ7mJKNPWpJW5+HhS5xyiq79273ZhBOb/AVrgshGg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.10";
        hash = "sha512-ofLnXEtABCJ8yffAFVf4xAVjsTT0zV3WgtpZgJPk+65JdI8kFEtgK8lvFTxM2oBF2j0MBW34IZfoJ95COTIS3Q==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.10";
        hash = "sha512-Iexsz5gCaobdFA3syBBAe5ecGedDe+oVAjSO850Y2Ygjm6X2ZepfO+oplylPRxLop3Ed+Z/2C227PprCNosQ/Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.10";
        hash = "sha512-QmbEwE/9CQ/awAmvJkRC6vjk6ZXJKYUDYlBdn4SYlfOQA4dC0RSBnk0SvfvT1M6lYsiTJ5POnjSEkBC5q9JXNA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.10";
        hash = "sha512-5HSN4A1RvCzxRhqEQ+ZKZAYosFKHoMYkBNddy+IK/gmSLPFTVNcGDo1G3VdKYHmEDqGYj0gyVMua9XcxBe/p0A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.10";
        hash = "sha512-sg/GDMOmRVRAcZN9m68hIvOcLrcpl9WVXA5e5y1fhWsEGbylPRT5wb6f7pppOkazcpS8k+4qetyV1XoRq6PFYA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.10";
        hash = "sha512-MsNWABHql3qNXNbdfJKnl1PEqpdC0Z+YX/3eiJVD/09kh0uh7o7yS0YmKUOJhnKDuA9DDkW28XDE8mlFe05V1A==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.10";
        hash = "sha512-3H8SP2lGROMHwc38GAddP/Ive+IPx3GKoaOA7z/w4q/XyD3XRU1G0lZhJQGzqWRadzX7AfQPsKUK/IB+VI49NA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.10";
        hash = "sha512-3snw7kUZSvSeUo1M8bj1jRCZFxwayp1kWw9/iz0n2eDy2rLqBtD96yzNOarhRABWJ1cxBV+es/pHQUOUXLkR0A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.10";
        hash = "sha512-XH8CvrUStID8cRum8gLsjYuBlIaSZa+y+hXSLS9z0S57LCSsTnGTSb2Iqc2jWLahcIOCZfEswmkFQyd77NJBew==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.10";
        hash = "sha512-64l4BleVOTvV5ARKn42Po082B0FgxhVkSEEHkJBWvxSypUzWm2nwsN2XiyoOtWYHNFtl/iJWH6IgdzOconlWEA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.10";
        hash = "sha512-pjqrjGdvvnhO814RO/5wdBr87oOM0WMlhFmbw4+6ZOhp7UcNjCdI4khSGdVleWiWxO71gtX6EzQxoj2POoRqFA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.10";
        hash = "sha512-qT5DaWKFw777elmcmj8TQrTw+tdTsBaucL6W+ylWWndGc0+FtcDjs/0WEdZaRlcdTOu7KmjyMgO5YvXxdQ7kUw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.10";
        hash = "sha512-ZLM/G92uE8yuTwQvd2ccMOmZRDR11nlSxiP+GGaKUV+N6L/x5zcYT4RWMuEEOseN4aNNAgyUKjAHO3HkpbFtMA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.10";
        hash = "sha512-TDvyn0oygOw20euEuEuo4jLcflyDwNnuV4VARBN0LXVwAJe2CpvaDdXJvqY2lU6C7XJItjz3wgjLKRZl/nYJNw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.10";
        hash = "sha512-BTjSDe9WDuQmlMZywLlt1zaCNNyI/KBPxh9oi0/EYsa7fbCQeHRba9uM+wzD9VhJqELz7ZYX2L9ku2fqzc0r0g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.10";
        hash = "sha512-xxVrIcfQzEAoAHG3buXr/nKgkNZ9ybrUIXJEyVpuUO9ZTGEZ7Wm9nApHXGi9DjIXs/Bts4QkdX5Rsds2gTStlA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.10";
        hash = "sha512-TGF4ZEiGwjDWFSQcf3ASYnkN8BwokQ9oe8AacafOKY0Pt6r4hvueprXIVj2/7mMjyCSwEv9TEThP4xUfo7Qjjw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.10";
        hash = "sha512-K/4GL1sobDGftIqLMYkk+v96WBOawLpeuys4ZzdAxAhlajO5TCR46VV5rHU8MTQmgpOGbH2v7dg8tCn1md7ccw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.10";
        hash = "sha512-eb/xl5MprW8gAwcsOgewQ5878WSfk0gf/VfrQa2OKM7/MVKxP38dABzqh2g1fpUsab9OjCFj0z5+OUnlOhFMRg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.10";
        hash = "sha512-Vqjf1BKpqXClSKJmI2E2jExBnSeMTSWB4g3w0WU9bNPGUjwQ6RigRgSOwhL911r6rYyRRvQXxo0hcoReRabXzA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.10";
        hash = "sha512-X9Y++ZhYoCyWPpEGy5eryJ9fT5s99dBSYtxzhcCDrELiqAzaiBj4X3TVIbMyOg35NOFS5mJ+cFsraZv6J8Vtug==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.10";
        hash = "sha512-ofbxEJLm8yVOhCEyhlcD/21u+WU3Ln8TYx6iMujVTBDpyE4PfLsO9kgfYMEwiLbHSqUa6V/9y7LYI/6HSuD4GA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.10";
        hash = "sha512-M3N2OsrgMMEcDJdP3BZyQTLN0Z7/YFMcxodn/0UirX4cU1iFX0r8yCyYYIQ6P0cinhaBLQ0U1WZaCsm5EkTtsA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.10";
        hash = "sha512-AAs8WMOE60soiZkI4mimuCBo0uF1Nfh0JT0wSCeCtfDQZSslCbYOgLQzIiYc+q3KBnquV/hTamotE0h8RG83jQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.10";
        hash = "sha512-x2UfHWATLb+7+3P73ZT0aDVepq0SN6npBZHsN9KGs/yTNhHVJnwgv0lqCrbTirFD0DfXtdoj1XwESxr53QQwXw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.10";
        hash = "sha512-1teTiGGnAMO4RsF5X3sBfe9oR6f9pFi5T3IgYIHKrKvNmj582PRqsEDCy42hqCMxzqpNEP8V7tnAHZnHrIDA4A==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.10";
        hash = "sha512-/2Ht7wInhxWE4zBsv9itb8mLrM0M28BWCDEkFNwbaMtq57qE8FysTU/+aOL+0WcZX9wAywOOBSm4Gw1Au9Staw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.10";
        hash = "sha512-/d97NK+ijD0X1RYC+lJfGVjjNYMCswoFXgvbSVdTaqyYbTyr0tMqkQlvxvr4Ty711bPMUoPeqI7R9NACcZe/ZA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.10";
        hash = "sha512-d/6m2bwNP35/bBDmtNPb0GBLwlK0eyM8/Qb7zEtIFJDgjAo960bROUlB6XcuLM4VmfA8hklOgGDU98nUg6xDwA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.10";
        hash = "sha512-YycqtjiXM2T8D7jrwwA50S6mGaCVVvou1w+ltPck84+n33WqVHcpaLWkwAV32iCwNwLtNCTImYyLgJxFHEQCHA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.10";
        hash = "sha512-3jG4zxQz0lz+CaCWlHHglAGQkII/GxpOKBDi4S6e+0QWNyVxYJ8YoSD7/rzLYlW9E1t/Zsj89S0CIUmdvj6peA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.10";
        hash = "sha512-m2+b7mdgNlq4Fsekqlsj1aP4jJ7DyttqlVBOjKpjIXdvJu5s53R7ZUz9fbWibA0sVjdJKaXRV/iBJUhvXFMxEw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.10";
        hash = "sha512-W6aeu5YQBgpnekZhGJPAQMUwRnSvJaut0lEuEtuNm4MCQRek9NbjQPRHnzlDrYG+CCaJfOJ4pJxdLb43s5Li3A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.10";
        hash = "sha512-fE0Q4TTiK1SsLKCUhnfdmcJ+ktZIao9kjY9kaChA7gYOe+i29DGKyuRxM6S54eFOpUO6UWRUzGRlkAI5WI7h3A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.10";
        hash = "sha512-pDjgz8DcSc9l4wOBOYhbl+TTH14qtloqq1C4rvkIsN7I+WEgWWyfOinVWcz1mHdaDPAnsrOl4XnPB9pNsGh4MA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.10";
        hash = "sha512-o+sT/o4Xrf6vy/ovS6gnX52ynI6gc703zGFlNklhOawS9R64C4+mw+eJ8UZ/Htp+qXH8AxXFxpU37VAW5hl2lw==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.10";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.10";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.10/aspnetcore-runtime-10.0.10-linux-arm.tar.gz";
        hash = "sha512-imYzD/7qrmmjcjjutDb4TIrNmvUwwy+fSDH7So7db7hshG/uBcEuTPR2OsOTIAb4cBoplu2roUtyXtshA9hmJQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.10/aspnetcore-runtime-10.0.10-linux-arm64.tar.gz";
        hash = "sha512-b1razZuhAv4sOlI/ByW4Leuji/unO+CuxML7k/CQwdQI3iLxzNLnx8pxySvPdBlcy541pipmnCHQqqgoVLI9Cw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.10/aspnetcore-runtime-10.0.10-linux-x64.tar.gz";
        hash = "sha512-Rxkkn8rKdEuO36W2UzZsq90l9FKny56WG4Zx3dL4Ds7vS7i3Tg+tiZ+T5cfIsTiJD/C9tJ8trstIlFXZSHpXKw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.10/aspnetcore-runtime-10.0.10-linux-musl-arm.tar.gz";
        hash = "sha512-KwZoxSZ5qaDZFNH6oV4zvINDBXRKcQIECmYjLKTC4QSTMLQhEjqJEzry8oforRVCZCMy6F2OLUFPMMwyDSR6EQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.10/aspnetcore-runtime-10.0.10-linux-musl-arm64.tar.gz";
        hash = "sha512-qNluY3adSPEWZ70A4h7KAZcwDUlKgR+o0LmyKN4r5vgxBu2P5Jvg5rSkQKUHo336wO/Ft+YSThi8zMGyxm46ag==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.10/aspnetcore-runtime-10.0.10-linux-musl-x64.tar.gz";
        hash = "sha512-qeS4SCPsiV+9zk7OW+rJzJOw8CxQPiZ5+gCkabB9x69DCZAMh1ii/5oaJbLQhfsob5o9QReDuKGrwL9H9RsIvA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.10/aspnetcore-runtime-10.0.10-osx-arm64.tar.gz";
        hash = "sha512-54fEAmqSWqHd+m9P8utn7pW1rL7l8mJGpubudzJkwNYpbVFT/tb1BP4MscyPRjYeZqJ53s7HLT4jCv5d/Go0Zg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.10/aspnetcore-runtime-10.0.10-osx-x64.tar.gz";
        hash = "sha512-4A29BXpJJt95XoSR7bJOsoWFT9fak5i9i7uQZLmWcgs3C2tHIB+/XYxL0YmzCTV0X4iNyASvBJhakaLRIbwNag==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.10";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.10/dotnet-runtime-10.0.10-linux-arm.tar.gz";
        hash = "sha512-zdXlumQ/kq/MCoHu0KlUncnDkd066fiFxkX5L0HYDKa0q7p5Kwf1v2qsK9BQfVcJzcKrHhoAVBSP+qSMFM4Qpw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.10/dotnet-runtime-10.0.10-linux-arm64.tar.gz";
        hash = "sha512-PqKsYm/bDya7UvAlhK5eaO6IwnXnQLNNk5GK04CYXQ2/oWMsAXZY393F+6OWEUtidI78EbJYl4d4FKSkxQIu3A==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.10/dotnet-runtime-10.0.10-linux-x64.tar.gz";
        hash = "sha512-dLK0HuF3/nLaAnQdW6MOijxerUQVHXpyoE7YGgqTPoJ/X4z8wEi6To3lrrdlGVN2G3WGJ30LzOLgEyPKKcy4Ew==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.10/dotnet-runtime-10.0.10-linux-musl-arm.tar.gz";
        hash = "sha512-NdAVtUQFSTZIWvxNmSLYAC/cIAdX3jxNDMf9uUIO9+cpsJtM487ELaYzkySlFskdJkuON8uX4s0CWYtk1gpXLA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.10/dotnet-runtime-10.0.10-linux-musl-arm64.tar.gz";
        hash = "sha512-HpftBykiVHtYSalpO+7kfTC84lXJRHaUmf4oZbqf5fjTixiW3i+20zkBcpjcoRinRKUoFceKjNNvuWxxGOGL7w==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.10/dotnet-runtime-10.0.10-linux-musl-x64.tar.gz";
        hash = "sha512-MHoaxIKDqqEUKMxNW/vSIe/e2EnREGIXnwW2+Ijzlai/Upz3sz/3y+6GujhrMU6g5MzUiWKy+hHMqjNDvJKUYA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.10/dotnet-runtime-10.0.10-osx-arm64.tar.gz";
        hash = "sha512-ecvGS/64BtXyqeCiou0zbHqidbBDi72I02I2obYgOVBUa0n/MHzFBnyJQ0/+IsAhpZSy+K2tcRRqXs6CVlK9hQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.10/dotnet-runtime-10.0.10-osx-x64.tar.gz";
        hash = "sha512-Qmn95dF77gkvR/tjOHwLsatYsh1K+OsOrRGLUdZ3/H2tqbj0bPPR4lRJwH9+A1CTjNdB6ILtQ79qsVQdzNSJ2g==";
      };
    };
  };

  sdk_10_0_3xx = buildNetSdk {
    version = "10.0.302";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.302/dotnet-sdk-10.0.302-linux-arm.tar.gz";
        hash = "sha512-rhnG1u2EjypgIi19pxSu/b4owOsdfhvfIHpeEG2ECEWNMfG0Fbc/9X6jxWurD4Zo96+i9SfzabEw0KA2a8TIVw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.302/dotnet-sdk-10.0.302-linux-arm64.tar.gz";
        hash = "sha512-nkCcFOAGhtZhx4+k3ZrQ5Nz2lcMovV/3d9BbSpw0tCz4mxJXO5Lp+y9WXb4SAWtINfd8fZpCtVp0lN8hY0zV1g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.302/dotnet-sdk-10.0.302-linux-x64.tar.gz";
        hash = "sha512-EAab7IeDWWSEphAzLwkNVigCpBubQOMyelpWiLVy4QwpauMA+UDUBGHyPBV+0bCEPC+Oaz8g2NjZ2DQy2BQ7rA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.302/dotnet-sdk-10.0.302-linux-musl-arm.tar.gz";
        hash = "sha512-Kg1VNbbUe5Bq/iyZ+EbjS370BGpChR9Qoci5xLegjwUiwONhLVhg7yQtBs3z809YbXdu7/et7P06O2ukUmWvrg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.302/dotnet-sdk-10.0.302-linux-musl-arm64.tar.gz";
        hash = "sha512-QBCXBLi3bnvMairRsDV351nY/8P68mFcra0r8PlrtJHzgrRJuJ6yvAg+tLgyCub2pqJKZc1OSwB6r504Pp7PFg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.302/dotnet-sdk-10.0.302-linux-musl-x64.tar.gz";
        hash = "sha512-rpT3LCo20LaPb4Ie4p+BJmm/DPLw2+C1h57O2aqcx0DvFNXjFtlGinibIUwREwuuZINybzwhyhcmVCruS6QRYg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.302/dotnet-sdk-10.0.302-osx-arm64.tar.gz";
        hash = "sha512-siht7JF36LVUP/L+lchNs1i4fsKjag00opAz1wJ5lA/RE0r1bEKZZI+JUNstbONSN2mM8oGNmrxnDCwWZMkqwA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.302/dotnet-sdk-10.0.302-osx-x64.tar.gz";
        hash = "sha512-SNWGHcDWyceCxtFj1rM07KwuvWWhrlnpzluT3QgKMdfs/E5NR+DjWyAc5jZhIY1kHhVAIiZilKOouEWToBnPvA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.110";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.110/dotnet-sdk-10.0.110-linux-arm.tar.gz";
        hash = "sha512-yanueLRtalpKaBxtL7O1yy84QZUCUo1MTBeebndYgCB3OHFCwkmcU4w7UTJKriOlK0pktzMarXwTmK8watyhYw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.110/dotnet-sdk-10.0.110-linux-arm64.tar.gz";
        hash = "sha512-DTvW7zQ9+8zbBlw/EkhKZ68wdy/SC4P1pSZ3ZKyvzGfMeCl8P1T9BHuJkHXxeYrSaePk6GTZwLer2fZ/qaQ2lA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.110/dotnet-sdk-10.0.110-linux-x64.tar.gz";
        hash = "sha512-BeWiLO+fQXSLvWNgKmtZUyK5EhTQO5oA2kPWmFAWSBNvH7Kk/mzmrZxoSqFpg3aCHIdTrwxC4za491P2wHj7KA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.110/dotnet-sdk-10.0.110-linux-musl-arm.tar.gz";
        hash = "sha512-RVTb1hfZW+kHnYvV4DtqbH0QGuLzkrEzJPHYTIJcu7w0XfqWWvgQNG2xo/4cNpBHL81Q+JMlMl01AD1Df+4jSA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.110/dotnet-sdk-10.0.110-linux-musl-arm64.tar.gz";
        hash = "sha512-kObNIhdRM2ebZzqcV11RW38bwYd4qqTeiFfNloNkllUH/qqE5vfGMMBAaCdJNcE/TA3sLUJju20gtc8RJs91LQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.110/dotnet-sdk-10.0.110-linux-musl-x64.tar.gz";
        hash = "sha512-qOg+jQ4jFWwSnah42D+XnpJEKQrt1ezlIwgUdXi8wjDvRKMm1dl5R3fSS1agfDx73SJb+P2MhE+YnmH82ENgjQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.110/dotnet-sdk-10.0.110-osx-arm64.tar.gz";
        hash = "sha512-oC/nq0JRualOU3N3L5mC8s/lsekazTMHmtTxGuKGogK11jLl85pTDWI0WqkgUU8VKjHHr/Id8jBmP1g4G6wLsQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.110/dotnet-sdk-10.0.110-osx-x64.tar.gz";
        hash = "sha512-a0FBb9slaf40s7pdtDrrvJVE5XrUrS0fpX38abOApKn08OHY681RX1KEhRhmNDS+4O79Tjx0d0mKAXkOzZn57Q==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0 = sdk_10_0_3xx;
}
