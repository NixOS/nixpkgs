{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "8.0.13";
      hash = "sha512-MgSCr3Rq6GgXQajJ7r3j96vIGlfwKdJd+i5gp9FSfKFMagJ69dzdqxaAHvvpxiuyR+b4ssUW+c/3gNmpze3eKA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.13";
      hash = "sha512-YMKye+unHqv+lLVHmy/H2YTbs8DaRpcG+K4D3WqivPCoWGX6fjNvtg8g4zR6axVrFNnKczwQJEL34wetUGx61w==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.13";
      hash = "sha512-pWiKiUc9qaTLlZ8/kVD6s7jEYJTCAfqnphxCOJEXkP1wOcEpMWN9d21GK9ubOSq63IVAAeKmA2DoRFItcyha6g==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.13";
      hash = "sha512-ZtwZhoOO0WvuptMPZmvj9QUzTNu19OroTihw6qtJS8vUreRc7UjvqH7PvOFdwgKtX1r1bDLfdR/4nRuIwoBRoA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.13";
      hash = "sha512-tJMoj/QZpYDleN/H3UghIynxnXPRgMPdrx1uqvX/3wnjsIme1ExM3ZTkZ6enJjAt73i6FVEWQyXTVczczgabDA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.13";
      hash = "sha512-UMv8jGREl+mz8P9MS20y2sWWbkGZyn5BISDz7IVlEgoY+qxRkZX8l7sQqq8XxAM1BkZLy9PM6JtHQSv+VMI7Qg==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.13";
      hash = "sha512-suZh3YYsbkaRQOHRRtdozciCJHdxCEWV73tGBQZJzc0dFYRh3FsfYxUtDACpbWRQ2IZTYJawrEo7mZHUwXcPtQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.13";
      hash = "sha512-W9UdnWxyclcioXrchdCpsQDJqnUtCS+m4aWRWV+2ejskgjNjUyiOrpYjQy+XVE5bW9krwd9ynOkD3KXL91sDFw==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.13";
        hash = "sha512-wPiH6xLRHVjd6LiOc9xEOJH+LSIamyZBPPb3VxdAOeHxcD5WjyoS7rUhI/M6DqufG6Gi7VMhehP9lLejW+2zFQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.13";
        hash = "sha512-eDzhFaPa70k8gUeu6rbr7s2aOfFSvwRkwTCoY4mVERmsbKtrwCLERhv7vuw/ze8lqloK2oXwwybL1ekOUKa94A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.13";
        hash = "sha512-OE4/Anisy5MjaOKxAhIU4b4bFjNaKW3vZpCVwIgIBcVz/WUVKYrTywEH/UzhEPqbJ/P6PJ6SMjYmdQ+bColVDQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.13";
        hash = "sha512-UR/FmEeb+HuVKOGLxbCF8ksc928eqxLy23ifwRBX8dFiWs8z8s7zXtpFIvH1t+at5F8BUOv70aneRhQ2Wgs1zw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.13";
        hash = "sha512-kWVbJrHvjFz5esVjTElVXjgS3tGH9NsaTHLQty0De7bLqrbrzKKu5OUSNdL61ev7QwF8R6iflfA5+/UvVYVkIQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.13";
        hash = "sha512-PUV8GmwwmK9aPFWdNo8HwN8UC35heQNqU75AszWHXkpfqnskuRdFYHoyUjxxvVlBXaen1xymXw/YX76NDoZeyw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.13";
        hash = "sha512-U0nbGfOc2+6zSOFNCZGhrJHQnKM3LZcBQqC0XGm4B0S/5wvZmrsLx0GSY09/EPmldWuSzaC3Exot7mC0NvUYuQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.13";
        hash = "sha512-PUsBDtDOVrGhaqyJh6D6vVJ6DBLac87qV7MojLNXEeGKn7ClTSzr78jneOUOeGcHFrinQsX8PoCMehszYjdomg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.13";
        hash = "sha512-OAoCKmvnbiNYswLUGGZeV52PbsYyNN0RB/Tj7UdYc9V3d6LIKrEweKutQ/zJznInNWkU0FwG1M6nKzoXVDNoFw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.13";
        hash = "sha512-ug+DJuZxtRkMOFv6Dhg5VkCiwtTJSWdOyfAkg/vwYcJvk1rM6wQwsLb1G393hmEnVqzXmhVaEi7CJE9Kp4cw5w==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.13";
        hash = "sha512-8QTpY+hdI3mtN1cqsv9FeUSiIPeO+SXFAy2A6VXd75Mb21Tmpy+u28p0iU8B7dyxPOYwX/V8qXtvnFfpSJrRVw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.13";
        hash = "sha512-a5TGVeUAzqJ0O9TkZ5QvFwTqLqTqY7XtcYEu8dPGzwyy2xHU0OHuQnpcVbvzNfflBWz0p8wq+O2th8D9DcR4Wg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.13";
        hash = "sha512-EJ45DHJtHOZAfJ9KbqDnjl5QwY5esccnSlCu1jaopNT6GIVibeRA+gycjrA99vPEqO2kK4fIrsEl9qOg77/oAg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.13";
        hash = "sha512-Eb7MuECz+qf8uGFVsGt4AkEt6+1DbIBdeCHqfW+Kxs6iR9zHH+Q8KeT/N2KQHeYPuo+Te6LWr3052XJoCdNnWQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.13";
        hash = "sha512-quVzy/EWr4xHHNo8sWPZIQfDPdMrNubaGdgEGnvmMuxTD+k06nWu3+HV00tNSbx2ruuPJMypR0gH1GUcAvAHiw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.13";
        hash = "sha512-fIujBcXM1ZPjkhxdJG3uavyBGC70EPMbmxaEAUy4sq0sMsEwot9XCxk9lGegnN/hro4Pv37IpWWpVYiMXb1GmQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.13";
        hash = "sha512-1cD9zMbdLSEC3U9/ebV5zOPGm15yfXw4coEQ4O1/2+pTwjwa3aYRoVVzYm1ptNOm4OufHW1E5VmurpJ7VJ7ehw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.13";
        hash = "sha512-GS1VSLt/2czy8XSLJMpzUcPAeHsKVrQGnHOkFTeJew1wsiMZHmmqftYKm5GAqCloy1wRMaMpiXk2q6Eu47xItg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.13";
        hash = "sha512-Gxi/u2nXIVPLA2kFEgChk4flm/1FCvFSth8lwO/9pqyoq5mD0uti4EF3Q9kheTR1YMCykmPPP1RIsJlMKkQBPg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.13";
        hash = "sha512-h6PYukUwYkY3FNBzeLAnUVxmmcOp2cmkasfbd+VU0lNmUP1MrdlOj626v4GY9tG1h3F4+I3Ry3XmgM7aaf7ZsQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.13";
        hash = "sha512-R3bpcLl9kzcnJv/t/SZTyYEod5Y9Eq1/DQvDhhLy994z7/2dWq236maUVstpqrNRyGRlk94ZLUDS1SQKVTCnOQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.13";
        hash = "sha512-kCjEavVZXespMRjSaY7sYxZiv7DEep+9WQ3fpC+OIy5Wv5nvd4kFEHDY4KuWRQ3DuSdNxEaAdDEib5tp+dSsxw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.13";
        hash = "sha512-qumZZHELvPZ7cXndpoTr2TIwd8aLTCME5GYXm85bKo03ruFsvg4sqlHms2XXTOR4U84pugHl6yJnzUSS8WT8Pg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.13";
        hash = "sha512-pOMUwywBQOla7x5XxBT8bhhTYrt5ZNznp2VjuRWUndJjn1XV5kfVoHgLBleWtjSdqx214+1qUV0daYigcfFjLA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.13";
        hash = "sha512-XqGPxuqe8+E+BnuL+6ZihrWQbxVUKWsR/9rjDHuGvPZswwGcXLAvzMLgJEmI3aR71yZL2bMskAI4p7w3L/A8dA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.13";
        hash = "sha512-gE2lw5wRrU4OQTjvOKebfOaWAVoD8qUkU7TiDnlcbUU44nWVY9SZ5Sxg1KTDvLQG+9JQ1ilBWB4xZw7nfoOn7Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.13";
        hash = "sha512-g7rwnlk3MNuah6el1YadnzQkaE6W0Keb+sKhw88gXd2rmxRegnmMKM48+p3KlmgbHER9c20doUcpSCgG1FSQCw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.13";
        hash = "sha512-eu57Vlit1LrSAKnuXPLfcxd9OVDG5o7FGuIJmRcPC6DOtQuO4GvKx6EpHjWpgDvnq58NDonhfpKUVdr6onY8Zg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.13";
        hash = "sha512-ve7hPhZeKIwPt33tozrAODERm2pK0F3o0K0I3U+CPCHa24+47eC3WNMZYoGS/CjZtUSD3X5YZV+U0jXU1nbXtA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.13";
        hash = "sha512-+UTfs0e7mIdkVb8zR0lqkaz9fsxgkoRq7BCsgPjIjyheR3e4AygDouuV/VnQtOXYHO48DIkidKFcg40mLlzAFQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.13";
        hash = "sha512-+FfRV8eJwWGTTHhnIKgj+YYVJ80l1atJ6shI+7BF5Pzk8eVM6edk0d9FoxYSrGpvDRvus393c91c6riJbc16fg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.13";
        hash = "sha512-LOgp9W2atSRVSVIknts+VaYJmHht+JCET3nZc5+8eCqR34PoFo2P8e0f/CZf673HS5ZUMEkgmDZN2lA927AB9w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.13";
        hash = "sha512-TjRXIRUfWjRpJf5rcXqayBRk12WaIWHrtkbmINY1n99Xk3bnw7I5EfJv6ard3y7WrLj//Y3MzPdvlCe8gtOCKw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.13";
        hash = "sha512-1rVdbT+vU+uIoQk5bl5LmJH7FZeGVzOKerYwNDYzE/aNIitJLLVAbik+Bv/29m+//E7OZOPdciGALFl8U0rN9g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.13";
        hash = "sha512-fxvgW5dSYuaVZGu5NVltyyWZwiZ4MhJVfQoeHEZI9VPEZ1EPBDLYjlIyWiyk0cW5+yEtZmkeNbcQELN6t8ms7w==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.13";
        hash = "sha512-pXWXxDcUgCm7xBUI10o8o23ZgDSAmG/rOO1bfzY74RnXPIOcraTpUoB4GgVIb3z7ERJek1B5W6roycag6B6WVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.13";
        hash = "sha512-vZcUK6f9IPTM+QBsoNZEuX7pB2p6mnBMcEE0ejK3LNt/3byj216Xw66Ur786bemJtq7AmEvt9173bbFUhqpsvA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.13";
        hash = "sha512-cJUogvZSX0tEypF9u+fiP4qn2o+6YPrJSCozxGV7fR+NgG/r7TXlEBNEE7zfZykb0ytM51bE5i6Sl4oMZwScJQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.13";
        hash = "sha512-z61zo1KZfSY7duX11vGC/Azgo8iF9BvrNTW7/IdGlcgv/mFM593qbyu5u5P6Slfh6+uPIT+usyyOsmfmwmJLxQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.13";
        hash = "sha512-wLID5tqgV8SIPLcZk74F9S2VJtPVSMKj5IyF4ce2zGIiADhPPdNn2v577xK1nZCySAUUj5gc87TG/mhUP2glTw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.13";
        hash = "sha512-tETOLI9GXl6lQRfc+Nm0zFkmietPL0gNWgNfrDG417PwKCVn67lNOMB4QCGxws4aai4Xss1Nz1DUws8Afowv0g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.13";
        hash = "sha512-znVAeRi4kfoOAzOGH7T3DQNqw2Qr5B4cJ8MQN2ys/v8PDomK245iamkSAzzeEwkX6IsRrB/WoWsHj8t+Tk/w5A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.13";
        hash = "sha512-QskMMrolVlrwJtSRM5yGkeEyybdyd87J7TRRkQ3eKpGEwHRMh9decBVnIT/TF+fQlnFldTkfWtCayPNMjRaeMQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.13";
        hash = "sha512-JiSgO5Hb74QjdoOD+pDUl+zd7XyD5xg9v1gTOD1eBMueuNHG4rbziMkX6ZXw0OHDdeidtfl3CO1HZe6WG2rYZw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.13";
        hash = "sha512-h8nywzrG0FLBePMdKUR7ypath0Bhdijo5mUuBfGvi41RNH/RnQYrE5G+UgSJFVJ80z+/0U0mqAvCz5tDHt6frg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.13";
        hash = "sha512-dbHgT93bdY2UPLWrDvhFP5RRbujswSxnBagSBAAsluiZ9NExyyOpLH/YVT6HX6o7ZFDu5SV/toIhBqSaoknrQg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.13";
        hash = "sha512-CHN1Zo8QAxbmEBE8Ec8W8D+gWFIbSS5jAE0kmjpJF5zpco1XX1W/B/q8P0FtoQHqMy3c4lHKsgnSPResPOjROg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.13";
        hash = "sha512-78reLCILq4xHBnubuzHLcET1YQ5exI6ZC85GHrph9OJxi0OSfYtoved1qsqUvJfVnLf0gBCZ3EDFHk2YOgEKrA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.13";
        hash = "sha512-lXhhyD/0HSr3F3Z+A+4AFw/KraH2ZPglwsoVVY+pVUgSD8SxeIWe3DG4T0UnJIzsB6S/pSQZtvMw4luYV6wMjA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.13";
        hash = "sha512-HWB4Hv9iNPIT+IEpve3O1Veo0NEakX0F1nRRssA8OjN2SSgaK99ziwnSBBMNdu9MsqZxRStmfvllE3TqSsm5Zg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.13";
        hash = "sha512-am+xIHI7h+W4ZBVRh4/Fkbl4SFB4T8pwgmYnLH7EE7cuBR+EFpxDXdG0NWtkVQQotTRbVLEG7W/WjYxkPYGlUA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.13";
        hash = "sha512-yfse5S0eD1JtJAqre5f8wIEoQSiyuv1zjmzckaiQ9aV7a8v0OlUAsic0X4X+SutrBaEMEChPEkW1qrhIz+FzSw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.13";
        hash = "sha512-HssZ+9XVCf0R8gOYB48tEJyBwhMSv8Wtb2IrlmIdp49Ph2xNhn/RYod3NEB2iWqtgappx6Z0RiCBW3Y8VpzQsA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.13";
        hash = "sha512-7d/XVFppfcjW/jzy9lh+M0y7QMwjfPL4A6/DC6HCNmjVTwfbV5rF6lEwZk4M8GKxnRBgKnawOQgi1KuTMrUPaA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.13";
        hash = "sha512-V5zIiUWCdEt+h6xfp48jmV8zd7w+SAvYmm9jEmy9Ik96gbMH9Sc2mdCu1eJn8POfBCF1iT231M4bUinhmHddgQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.13";
        hash = "sha512-V0exrjENWzL2ktHPEdxW/bdjiPhG+8GymsPPqZosneY/9nnDqAFbDeVgwu4DpDLr/LzWa8Im9W0w6lXVe03Ttg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.13";
        hash = "sha512-Qz6KG2nCsFyee92YeedAPxs4tVe8i3CtuYB13A+qTSmIeL5LFbGOeOBdCY0kUv55sZ7s/qHCcQ1GSNCLHydS9g==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.13";
        hash = "sha512-Hm5rfo+3bCHOJtoY24Fzqh5/drvQnT+JPblM1SzabMa+f1PYew0gcxGLG6KludoGP9M8aQQhJbtb09EJrINpQA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.13";
        hash = "sha512-NJk1E6+TtuZDc9N+tkTcnPhtHC6p1CC+CTE8EiXfUgBVmQUzrF4NX/YZ3kmT572H00X4pbwmoFQrXu2RuoPP7w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.13";
        hash = "sha512-FBFmvl5TVxqvWhpmdXkbQvlYBT2XqIv/29u/xeuvNL5lSA1PqMDA8fAeuXzGeGmTZOVvPrjpr6To7ngQ3g6Pfg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.13";
        hash = "sha512-DNEFRTH5gtEM31R4M3KimG6EJltwPFte/D4nqAJb/06ErjEU855/4IgkpHHh6w+y73wvJL2T+o0+7s37VLCCSw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.13";
        hash = "sha512-8/B5klBMKulU5Cium01CfdQynUQqMNjoBhgb0KAVfExIQlk9zKeDXVI4ObmvmsAyqa0h/jrkyjb8NF11j9EGJQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.13";
        hash = "sha512-avlyzKD0lmY/sOQMYgzcAUyEhwy9IIuOlmNPHGJgaW170Pwyj9TI1pDLyebHF0ySaBgpGS+Gl5x6UPnIlS/AhA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.13";
        hash = "sha512-f+AMJ0675qIFAWUNwIJpZ9FDbNJYsvRwbGXIOUAHy1eh9aJoEU1XFM6CTvP2MKwU3ZPIyBbUr0qbwo72ni/31Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.13";
        hash = "sha512-mJiSalZsnxHGssprUyk+WhXqDg8HclKscJ3Kod+ZVNqvLMIX0HA/WULzrZyfERccXMmlOG8BVo+IHxFnkgMIKQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.13";
        hash = "sha512-fZJ00cBTW5K+NFuKPwTcEhGMvOS3CWECpnFCdEWzcAbbjynTmukixV+fW3q5S+/x4vFnlWX+VDWOHaVakXN3eQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.13";
        hash = "sha512-WWUll8LGK3xmb8ri39/40tkOlJtbwWOqHIpIcKSc9rhD2UzmlnlCkKaeXORze8kcEIClUPok5m1fcOhpmMeJjg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.13";
        hash = "sha512-K83CeF/OvmznT9Sw26GkAm+zYkrIgqOx8Hy2dLvXZpdOBNe9R8JvBWq0DcIN7ksc+K92F1PxVc2S/pR9ZXrHlg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.13";
        hash = "sha512-dmuNR3DsR9BjvayJEEXk74eAZXqYjoPL4tYPXF7QUZ0LQE3WUoTHv4QD7QMEgb+HLNuPDNzHYj8EsAsQ0lZeQA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.13";
        hash = "sha512-Er7lYCDr0YqkbNCqzqBvJyIExkdtS5YRP5Xjce6pXi+YEn8s/BlrK0zr+/4OJWL0v9pJ3ZIB32QrfA80HxBcvw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.13";
        hash = "sha512-i/WIhfsMSxxxy5IVEtMPjJ1CmOZEEdgNui2TiirYs6AgxYWQE7Z2UDsrTrfaHp4sftG35DpfFtryXZrztRV+og==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.13";
        hash = "sha512-lPTnUhWp03b1mMj2wzmiLcDpGA7iqtaDo028cKhAMOsKre8ffyVyl7rwc5c6rMeSRgAB+lj+3qFXi5AgYsh9uQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.13";
        hash = "sha512-mhoMYBBulekGcEv29c5H9pXZToA56zKCi+pVqU7q03dByoZ2y2YmFFrfQ1326N+4WdnyjBTITK9txRglF4O3Pw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.13";
        hash = "sha512-MbwFIWq80Gc7HR3AfZ0xXJxowY6kaBwyMYJybQetBr8fV51k2NSOwQ7dbbbXQqFAYYbKv4/e+27anCOwUex9fg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.13";
        hash = "sha512-LStx1UzEEdHLfFl1mqNwZeRIDMSpGbpumQqXOJyKwudmZ9Nvly8xe1DGKHWKUy7bETnwdT+T989V1AHinaDdgw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.13";
        hash = "sha512-MY7r8G+jwzfr2aKpqZxtLaBSgWoeieq1JYDXaw88Arq+z27I4H3wdztzmq15zRG9R1o6gxSG1/8/0RlZAJESIA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.13";
        hash = "sha512-eZFSPMMA30+lum8u9BXmUu/By8RpfrFWqmI9G6/3aT3fxobup/ohVsW8SFgQ6TQL7qqi9DNmh284jNXxd7IyWQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.13";
        hash = "sha512-TnFmdxCBFtD9CPncmvZRGttCxq6QiYgj0n0lkY4C5JtFLvbjTt0r7DzZ/UHp0sC1fxowhAmpr9a/2GQLQRaAxw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.13";
        hash = "sha512-snaYORwJAa6Wp6rDdnb8RLibvNUFCbP51rhnZqXA6puxeygsCfcDfMkmKz0i1GvfVpoYAIeaZU2o+Q/kSKL5yg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.13";
        hash = "sha512-wcHRpb+C+bSXxKaMPkzGyPZJZoJP0XzRgOondr+DIDD8MqarJgGUCnFyEH36Uv9orS/3FufQAv5uQGsdpvveHQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.13";
        hash = "sha512-v8lYi57qnbb0VBekj6GtnTtr0FQMwPtozdrNDZ9s5Hvhb1z8pwYdXtkVXtJgv8q6hhjoaZwKYarcjnC5xw6Abg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.13";
        hash = "sha512-/T3731bLrjLbWiMLmC7ziRxnVQraFy4OSUircxxMkzEV48uIM03Y7sF/414vjLbtOP4aLWua6fiL7Gk/LKOQwg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.13";
        hash = "sha512-iXbeKa6+JdsdV4ZBo/hmSHx2A5zKN0XXh0+I3fwJd6dv1sgDTZ6LFOcq1oUVD30XRnbDOYUYUGPodoWQJefJLg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.13";
        hash = "sha512-Mw9nFoDzI11sc/RuquWRHBvwHPvXfzAJls5pgW5CIMTCCk/DzB8Jp6YwUlfS++L/VU/1j+cb+Ecce336Ozh0qQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.13";
        hash = "sha512-LnNGrhF33hiudP8mltLgiIqg8afLiNM264RcfNPZYw99t4rT0OyUuvrtSifpWExjZ3AnTyPWb2ALwdgvaIifiw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.13";
        hash = "sha512-pG5Fbq35FZHbuGlZeICyGzI/uVE2zi34ODn0sCd5duzt1Jld68r7pSdN+wCzTAeC0rgbZk07g1L5JNbrIJounA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.13";
        hash = "sha512-ayq2R7iJji+qmpTN/I0CqdiTAS+Vyz66MhUlU8PGQcjdzJj4EAxkViExpRsHU+JfJxgK2ZdRmFbQOW/0xD0PPQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.13";
        hash = "sha512-8UGHyAfbMnZlrxrLC6elkWv6UBwbleZQeDajV/bceyK/cVkDfI5dBs3MOt/LUWOPBxbpvcRu7Jix8c2Q9Fw44Q==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.13";
        hash = "sha512-BiodKX5nKXd7JNji43HFVhZwTLNabd9ZHMifgYY2tyTqrDwBmsqmUBF/iODtDIAqHLw1fhIpqbbnBMyJKJZUCA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.13";
        hash = "sha512-8XvPrzp8W2jUt++6uo/WaYhg0Hf0fHCPsxaAmxhnbuq7/IV5Iw0B69bvWuyuUiEcI7VYGWheUNmfy3Db+2iu1g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.13";
        hash = "sha512-PHxRlaZoaexI0Pk/VdEhYs5+k3SVnsVxQktSIIDU62WOwS9LnQ/zJJnvbyCgU5rkuzwES/+Z4lZvBhWohH5WXg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.13";
        hash = "sha512-BwGWANBtOuGWcyKHPRyC59Xz0Q01gOceosvTsxHd0azriG2j7GdJLWgBndBrk+Dh9plVE56PG/WpR9dCqznthQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.13";
        hash = "sha512-fA4AgGkm/30M+H4h92PvJ+wDFvRkodn4VFJWBqwU5CnjQoSAiJtqMNF7InRo8fYScIXcurHabcK8Mg4/zxHy6g==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.13";
        hash = "sha512-OuhVyzUqBcj/UK4t7PjBr8xtns/UvQ471V7ggmv7NiguciaqAjZPMYUvlZ5X6BY08gGkW8OeQS6ucLXobymxpg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.13";
        hash = "sha512-hFAn1Re+hn8cxLfMj2e4oN9lUD1n0hqhpW/k4tTClK8Mol+Sxkr8YgzNIW5CHQYrIrNMWSy93fXTiyuHRW8ExA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.13";
        hash = "sha512-83RSeioZopBFRX5AWLvPT9FpPGv1biseVQzovj5Man3TiEhfSLF9VzrTe+Ag7tVf84mp0+baLc9lrglGep6sUg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.13";
        hash = "sha512-PZr+xxwsxZ2WECruHG43ypvNhvEaSwl0aVp6ykMH70RWrp0SkeWDwSiP+U5qcSNzg8G2xZS/sq0pdSzZkdlPAg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.13";
        hash = "sha512-uk/07Gg+y9caMZyfG7ZRopXpXWpnl4198lkhb/IqEka1Lq2DiN4bWsejbA5Fy6U2KHxSlBr5fQ80JHzOg9atyw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.13";
        hash = "sha512-6n6dSU6+rv4b+6wNj8OOaNjRJirBqVCrsfvSCD9e701hwub5dzUTh80ZueSi0goBmbafwD8clZE3fDoCueIWFg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.13";
        hash = "sha512-AUqe2XlIVMqDvSiMnOL/j86s3s+wS25pwHfYS9fXNF7uJ0KDOHOKkmI/oh9UsOXHp0viCf3VqFeZecYIQ8JG3A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.13";
        hash = "sha512-FfnHphaf2+fPOm1Sjer2IC0r31V3IRx/yaPFCvPuTaieuATQ1OLqBN6oomFTySaO6nLcqgcJ/Q8UmuScsEFfnw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.13";
        hash = "sha512-OFvAeGSGCK63/9OQQcgYsVr0acd0BjXQMqPXvfafbkO4SxCK8Vs9VE7DJghYesZ/wGDgu6zuHfIfc+/LkJ8m+Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.13";
        hash = "sha512-D2dx4sp/lUJ7S/bMCj6ZMLxZ4OY0O1hazlwpUgafxcfQHXia4lV15iW/NiuwlTf7RdyXLwsxR5IjAu1zk3tyUA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.13";
        hash = "sha512-a88O6Ce4XyTTejrznAhAKyqssctCpHgzt0XPpe/GPpK09SP5n5lDIxBFw6DZ3AXRFdsMgQFKV7o52DqW1Fvqow==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.13";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.13";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2c764efa-2f8b-44d1-9308-87dcafaeff2f/cd8f6383aa8adb1dd9493520b57f08ef/aspnetcore-runtime-8.0.13-linux-arm.tar.gz";
        hash = "sha512-3lo9z6uqfwGq/7eLIVbZ151hTw5S6+YZZXByVoqw/Ef01T57V3p2IjklAs06c5QAr2wmmZJHzFDCmBO2qUz80A==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3167f98c-e2ef-4d19-bd00-178c27ed7f3d/8f9eb25b9899009f11ae837612b52c0e/aspnetcore-runtime-8.0.13-linux-arm64.tar.gz";
        hash = "sha512-1nEwMQ6B9yfx1IBkY/Sa8Y4BLW3HZslAg4hUkis6Pn9xcch9WVxNwJ4cY0cPrjAXtU1RvphhiYUSn/N9alrAsw==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2115caf0-c47f-448a-8ad6-107a742d2b9e/52036588ffe8f8abd87a3d033fd93b67/aspnetcore-runtime-8.0.13-linux-x64.tar.gz";
        hash = "sha512-eyGv9Fw8p8zcBSfG3gXCCdWKVqFc8Q5lZSImH4hM8nKpK+E2lrGg8a4rqqDYJf/aWNlUhxoXs8OoZZqfOjbH5g==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d0f6f5ae-d965-4836-a1cc-97e382e9e919/9bbf8231f856157d4538180e92f24b53/aspnetcore-runtime-8.0.13-linux-musl-arm.tar.gz";
        hash = "sha512-IKYyJAnkbwZPc505SNz6Nlh507/B5wTsJPdKzPnI9GSsV4LqyIzr821nMqPUXW7/K7SonjkDIzIojeJeQQZboA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/9f700310-0300-4863-aa9b-469020d64bfb/025c0192fbc5ff3fab066ecba8cd76c1/aspnetcore-runtime-8.0.13-linux-musl-arm64.tar.gz";
        hash = "sha512-zsHu/r/5w7hYJBf8iDzRmlzxdB8A7V315Cojk5jDKG+fjh/myaZf+9dvqVMYzyP3lB9H9hMvA6+8H6+jpIYBxw==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e3b6a163-097f-4fc4-9ac4-3e42f5d98a69/8ca03a327bd2dcb6b55ac066b54b99a0/aspnetcore-runtime-8.0.13-linux-musl-x64.tar.gz";
        hash = "sha512-9JksLLyAGTeK8MhGPTbJeMqpQ+U9SVIgN7gC90duydgqb2nfshePgvYZvO3WYg/wwaugJHYIZOsPc85wwE/Y+Q==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a91349c2-bbe8-4a89-a5c1-bf42b6916fed/9d25c6514ce8983ea8fd494ef8491bfe/aspnetcore-runtime-8.0.13-osx-arm64.tar.gz";
        hash = "sha512-RqGbkmHxPtWFqUpzJdsY1ifYRqNtlbY0IRNv5vVVfmWSXjluFAD4+3T1CYEW4g6JUEwUZ4ibRhjsrjqat5k7nA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/08747374-3c8d-4ff8-9ccd-76428ede4b69/d09395b7026ad4825c0fa73342f98a42/aspnetcore-runtime-8.0.13-osx-x64.tar.gz";
        hash = "sha512-umZ0LKuqeo4/9SeIpZtbprPrrEdOYGREYjyZGeJXsgue3XTpxvDSMs5+gj2/rXaH4klc0tcL9GZJ4ZAudLZMDw==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.13";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e42f6ab0-c3df-46db-83dc-47205f5cb6fd/0c1cf07866e0674a18748cfed2b747b2/dotnet-runtime-8.0.13-linux-arm.tar.gz";
        hash = "sha512-XQGPtQ7qlvPppWFCICzLHHOnJSGdclew3rvu8+8ZbGmwdrmN+28JiBjAUUCE3zP2cEvBOkeNFyewEta6nuoEkg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/7613adb2-d77c-40ac-b9b4-28f0f571489c/0943d0483052418201c63456b52a1908/dotnet-runtime-8.0.13-linux-arm64.tar.gz";
        hash = "sha512-5sQqwXWCOUBcinQBlAI7St4QF97zvzMFV9wWMSsvQFmb4wqL/I2wVVlknPDtpfxDrxUzIPU3jctIcq8TZ5vOiw==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d26516b7-7049-4c18-974c-467190461f3a/667fb6101ef1f43f624e175b49f8ab49/dotnet-runtime-8.0.13-linux-x64.tar.gz";
        hash = "sha512-hkntoU6LyZP4yz1CHUSkq7IYrPKZlqweyTloa/ZX51tg8raQGApGVO4V67e5U4bqvJaeqYIJ4x4oAWIP+Q/OQw==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2a7efa56-7d1d-4fe5-9913-bebde112ff7a/959441c7558e14cf628c30ceee03dda4/dotnet-runtime-8.0.13-linux-musl-arm.tar.gz";
        hash = "sha512-qMKEQGzbu475Cu3gqVB96vPO/Hlmyo3gRXa7s7riYLgbFrJEHU1DhXkuzDQX6hqzrs6rVJf4Zl5w36Ve9+WvKw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/88255cf7-e65f-4fa7-b9ca-5d4ce68ad28c/4f0cd54be0d4c52ada9c105e8641c434/dotnet-runtime-8.0.13-linux-musl-arm64.tar.gz";
        hash = "sha512-e0aRlkle0A2c+xZlWHBMIqxXK+EfxN+TbYaRLZwwaxAbo0EbaOlcjRmfhrpIyqQtnisGjOrie0c0fcULe5atGA==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c02c39f9-a695-4924-ab27-e1935b9f1bb0/860d07a99820abb189489d8e340e01b9/dotnet-runtime-8.0.13-linux-musl-x64.tar.gz";
        hash = "sha512-+sennennnKBVg6ywTAhrGlc62giVt8cwF2wYHw052oKsK6VCZoHe1tWx2QTpfFhQgsybVtjFIH/uPpO4ixOVBQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/dd971173-c30c-4fdc-aaec-015aa6a5e149/dee0d19d43982cdf456a7ab9aec99094/dotnet-runtime-8.0.13-osx-arm64.tar.gz";
        hash = "sha512-eUjTe908x/ovDVO0DhmXoQQLhm+UKoLrfjNJ2jiPYUr3iZA4ZIO8p4miK0GwuPXCUWC/fFgSsffzlK+d8btadA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0803f323-5b8a-4891-be36-731d42760b4f/13078be8c22cc327924445a898e74995/dotnet-runtime-8.0.13-osx-x64.tar.gz";
        hash = "sha512-iRZgXw1wKKgZAqRpLKY4ZSGJKr9NwgmDyI4EchA2h4sE+AoLkyneBSSr5ESKWShFh8SLc4CA1nXH51PjjX2abA==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.406";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/18b5dd5a-24cb-4e2b-a440-1089c67d112d/dace5ece95d3ba00c984c41c52ae2e4f/dotnet-sdk-8.0.406-linux-arm.tar.gz";
        hash = "sha512-GKK/V1ptiVzgZxsi5PCFMAOSDwt/LzP/Ra/FHTRFO/1rh7KqXlM0nQxq6fbDf2Zj03+Hou5UTImn9bqI1vZUCA==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/50bfbf66-b057-4bec-a9cc-69a43d4b32b2/489a1c7042dd654df0a71bcb9813067f/dotnet-sdk-8.0.406-linux-arm64.tar.gz";
        hash = "sha512-m5OfCfvaiggLEmaRTKAsTWCpXoX6ahNEw3jTlGl95pNet9lB3Zo665d62jqrVhxhSl/puXOCSJnLAqp06cCZiA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d2abdb4c-a96e-4123-9351-e4dd2ea20905/e8010ae2688786ffc1ebca4ebb52f41b/dotnet-sdk-8.0.406-linux-x64.tar.gz";
        hash = "sha512-1v3P69DfRpWfeFfPs76sfebIhDUV7OKLJIAnZf2c+2x+lwGzIBNMtJBzIpN6uJyukU3cIb9IubYxPpqa9cHySg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/542665a3-2d4a-4d29-bbcd-4ed8b8fcf247/2a1d158de1064dedef1d1df00335b172/dotnet-sdk-8.0.406-linux-musl-arm.tar.gz";
        hash = "sha512-xDOK0Yri4EJcTp1tUd0mYhfzPntkdUSDpuszuBuW9ugIYxQBBzAWYhHLlsyHyaR/t2rvw0MbA/KFzcriEZp8vQ==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f7de890b-abc8-469d-b019-a974ae2bab28/7ebf3f9b60fdcc4eaa48ddf154658260/dotnet-sdk-8.0.406-linux-musl-arm64.tar.gz";
        hash = "sha512-GWH+w/rmA5E0pVLRnoag6TAQ/I1dPUwilZ7dtFpR7rAMRwNzE5f/yoAgZNc7mEoaVX3apoN0tanaAU4TW16nUQ==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/31d8e702-aa88-4d2e-8346-59943c20aa82/cdcc353bf803f5584a823a866c969288/dotnet-sdk-8.0.406-linux-musl-x64.tar.gz";
        hash = "sha512-DH6y41MPlB/ButQ94fsIqk0jCYr0fgSMujJbPMSAd8qxtuxjWc3IjC7PZBPRusFKQ5h4sg1q2yxiKXRgGMLhMA==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/def16517-1bfd-42a2-98a9-fc2c2e95f47a/6ff352d2eb373495453fe9e4c220493e/dotnet-sdk-8.0.406-osx-arm64.tar.gz";
        hash = "sha512-29a/hwyhd2qPRjdmvF0LWErGNulH8tomJwi3myHUhHXR9q+DLfD1CeBLTnHZuyw3d16YeGKd6/ztfrazdsLESQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/23552ac2-5161-402d-a7d7-397c909d945e/28a0315d5442c2a4da5374e421e41e3e/dotnet-sdk-8.0.406-osx-x64.tar.gz";
        hash = "sha512-nBf1xz2zViAahWEMmUA41AZY0PaQprA4GHiwJsNd13WXE2qlboOdY5ou7OTPrW2ISGdVw/q2oaQkCqeTy5/rSg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_3xx = buildNetSdk {
    version = "8.0.309";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/099e0b19-f77d-4d12-beab-83aa92307726/daa887cc504b1faea56de7a422bd6be1/dotnet-sdk-8.0.309-linux-arm.tar.gz";
        hash = "sha512-S2/S+EMQCQ7SkEJiRL0/QRUCHl+s+S1m+x8/VljkJ9syV6X4dUN0NXKWY8UfXol5kOTv6h6a/JptqaoT22wN3g==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/bce5ec8b-ca1b-4186-b059-82dbc61d3482/64f97623037cd1975e06be3304f64e4e/dotnet-sdk-8.0.309-linux-arm64.tar.gz";
        hash = "sha512-QoGJHp7x5QK+/nvqXl8//oQRBYNhHx/EZ/JbKLf5Xs1uWMHFKoKshgS7M4Bvt1MhqrmvqYaXvdsHLLBGIQFStA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/54c4141f-ffd9-4492-b224-50edbb478d50/5a9a16cb9918e3035a788f4f294225db/dotnet-sdk-8.0.309-linux-x64.tar.gz";
        hash = "sha512-8hOqvH9FjOIMoQ9yp+YAApfFdzfmGBgAXvA8RckH0Ls3J8+egoyrudbT+zvaSrwYvNjkU7xaAKxNd+YrMjf8tA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/72f58242-4dd9-4e83-a251-dd331bf84895/724c31f93ccb5468646c0596846abeec/dotnet-sdk-8.0.309-linux-musl-arm.tar.gz";
        hash = "sha512-aBRheF0bKrfEAwm3LOcC0BfpV+LG6gwrPqPTlyIZb/mrZgSHFexCPOi5zzVCriTkKxUi0Xw1JMFzzHqjVCjFEw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b43c92c1-69da-4ec2-8f31-2c214e1e19dd/69d274a6bc86ed72f7191726918377f3/dotnet-sdk-8.0.309-linux-musl-arm64.tar.gz";
        hash = "sha512-2+J98xfPaqFwHQjNmgdB5o66JNX0BAlSeVtzVRS0cdMmkEVRwqNJr8Od2zdzOpB8Z/2ewgu1RcKQIDc4QhCt+g==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/de135166-9d03-40d8-9890-bcc49686d2e5/52222baa4072cd556802523cff3fc3d7/dotnet-sdk-8.0.309-linux-musl-x64.tar.gz";
        hash = "sha512-/sYUa1bvfWF06mQoa0Mb/0DH1dyn7K8fYYDH2jB8ue56lAWqkjCFuEmry0EQDKa+/RUWw4ALS7YucTEEyU1MdQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3770f177-a18b-4ecf-a596-280060759ab8/1bdf94195662387d2d0fc4c90b5909c7/dotnet-sdk-8.0.309-osx-arm64.tar.gz";
        hash = "sha512-Y5m8756r2FOgnKafFougoiS3RD0ZNVfzvSJOn+b7TQVTbSH827z1qe8hH2GhByoeiFBEr1MdZ4Nc1VwthnrCiA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a17ba63e-bf54-4591-996e-d74d5e1138bc/343b525bc3bc5d3be10025136afc2e47/dotnet-sdk-8.0.309-osx-x64.tar.gz";
        hash = "sha512-EWcrhD3Yk03LInsGitmRE74mFnlcG+2XkoOvR4AZ/20ApYVhGK5NGpKXg0NyHpOkansng1PTtXE7tRqZATz7ag==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.113";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b2b1ff12-96c2-4de8-89a3-a17d533ca8aa/d45afb562e840be15870b23453dd672d/dotnet-sdk-8.0.113-linux-arm.tar.gz";
        hash = "sha512-LqHqv9emav1vtIkSujqKemJvw7sQ9fNUu+ir84QcSJ2CGuFnCyxklQfdNKW33GbprFSADK8GT+fGeg8GXGjCRA==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/617f9650-3648-4813-a80b-ae9376f9926d/9d31940b65fe9e2a4debed7e52779e86/dotnet-sdk-8.0.113-linux-arm64.tar.gz";
        hash = "sha512-w8soWKF91NvqXTxWh+nGSLKLGdtSLwKXBanc9hSH5SZ01aDt3Wx/a83cIpcrTpP72b/6EOKvuv7azjElkL8GCA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/906a5846-9fc6-4755-9e58-5cd276b62752/05b51efa10b6b81fcd5efae1e71b6b8e/dotnet-sdk-8.0.113-linux-x64.tar.gz";
        hash = "sha512-58OBRcqO2yP5mSq6I4tnJe8L/MGGyHnnA8eUULd3IJdomHUaKFhadtObKltJnldj6OshZciKXS+rLDEpo1MRbw==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/fe9c5dad-1d0a-44bc-991b-b7261a101acc/f92f4c4ccd929728a5be49219a77cea2/dotnet-sdk-8.0.113-linux-musl-arm.tar.gz";
        hash = "sha512-qN/OC2Q60jySwzz6ajYmnT0iy+7BzbUGGhw1+Syg8zd4sLKN2f/xFthUUepH1gC5t2LhN0q/9FDqf15gNueSvg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6e40c625-e084-43a2-a20a-84ec80538994/f7c8c888a5e65ffdb84b3adadf6c234c/dotnet-sdk-8.0.113-linux-musl-arm64.tar.gz";
        hash = "sha512-U5Xsmc+UiglUUFSZXvio2S1iK33R9nq3uwk0Zj6gZ/+ZKaiYOo3efbPt4KzdSeS/id3xRIcpcEjSjV+047GhvQ==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2db21b6b-c8a3-4963-bff9-51e95e9400bb/16b322c3e86f65cd7c65c78aa114f341/dotnet-sdk-8.0.113-linux-musl-x64.tar.gz";
        hash = "sha512-7BOirKMAOYyHOLHg1Ixu6PfvIY2qS8DWnd/AT+L75AwrLT1rHawZD4P8eUU4TWa0qDCTYy53iG+1S3i8ojvmNg==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3b72fb20-4b11-4fba-a251-5485e059b6f0/24211930ac082fffd82011261a38060e/dotnet-sdk-8.0.113-osx-arm64.tar.gz";
        hash = "sha512-GCR0ebqmsXOS1tjT6iNQ6leGWAtBnUHoYvOxo7ndZazHMCpqv2t88VnwdiN1aoSYItEVBB5yHfA50Xk4Jg3uVw==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4447b07a-1f8a-4088-8de2-cc880f630c11/1738874168616ec1522ed1effecc15e0/dotnet-sdk-8.0.113-osx-x64.tar.gz";
        hash = "sha512-ZPGThYjblhBKU8c4GrFwdJ5cQ2TEmUTcqPfJGNUirczNy8PPcGAVmbMGvejoEISafYt4P6sqve43Z9FJZTXpKw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
