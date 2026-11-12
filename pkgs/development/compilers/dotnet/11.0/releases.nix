{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v11.0 (go-live)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "11.0.0-rc.3.26522.148";
      hash = "sha512-kHY1S4k2aoUnjJJOvyxSBywlDV0WgHr+CBA2EwqF4hqjd6Ye40NSobIz6OB0auvK5j3ofbDQ9yXT4NgGulw7sA==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "11.0.0-rc.3.26522.148";
      hash = "sha512-/WjVHYSSnRAgNi6NV7HlT9Sa6xkZOxWPCzowenyFhVSyK3LBGQNFkkjk4usmQm0Pw2mTZT+DHLPukpR8zYy5OA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "11.0.0-rc.3.26522.148";
      hash = "sha512-JMfztR7v/l3RjQR27R36/icRx1qLOwYVvp6N4N6BzB7S+BY8OY35Nyx2sywWalTz4lRIUQ6gkI58Nl7BrBBOmQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "11.0.0-rc.3.26522.148";
      hash = "sha512-j8tl8qNGsq8/x+ulBVTXOjRF1hvMpCm82gORO6xe7rFn3MYicZuWdWOD/6gm/6wsmWqdO+P2QxWEgXmqgkNvrQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "11.0.0-rc.3.26522.148";
      hash = "sha512-ZLkg9ghP6xBern0790tFqVoF33aForsm4DZEOssxgOYVqKJEDKk5tL3RA5EftRJARqVx+VgyoysowswyZvnPUQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "11.0.0-rc.3.26522.148";
      hash = "sha512-nD0mSN9zKliWuQDKeL+sdOHVd8Y2H9cmknQRxcqFqvjJb0JycVD0xzG1/E1oiUkcqPThrODglG+Y590ouH4C2g==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-GOv0S96+17OhTgnko3RJV/W6PUxbmsK+i/nXYqBka3MzpfKG03g/OaIbCZYVm3SHdFJCH5+VxDyfxMKXxEXMBg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-k1GHIvP+SbCMKjQheo5byLtBbKDYXg3jIXIuNSwmz0JGZ26w+XWPrZXZC/FVC7K9x93hu5qU82a5ZqCswRRfCw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-0L9BtGU8BGFONAJ7EG1aZiYr9NICkZvbfRU50hQDn8U/wdv6B4sZd5gu6jZ/wq4Bbln7gGSBMClxkUBW4hFQ9w==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-Rhrw9lnZ4O//ZXPI2C8jHIDrHg5Yd4e5Zww9o/ot9rHIF2qE9Hf/+0bYucIEPAq7kDfv/OWkZo94VzC6tHbT0g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-IKe2pTQj7SHSPXtrhSekhNwa1h32Zkbpi204Q7kFXQAGEWzhA8+SiCkOXVd6zTv2sOsrhVgEtx5yT7DLrB1f2A==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-0XwNaAdsgOfAzOmvPjnHoeLpEh2KWbXnPc1cdF4qC35hGJBglWeqmz7vMLM3KXFP+qb+mDaNjYVlPUyHA/kWPg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-ssb3mxa72ijtjOVg8QvFKv2l5UBcGzPiNZB3Se1hw9t3OKbGE6sdwQKtpLFVhm0Z0BJFEfKehaPuXdQqdAfeSA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-ygYBRXt0EmJSTmBECe7h/o8+Lb1sB1tSvqyZ3pQoB1e1id9g/YmsvA9hJ/2VDq+hoaXMANDn8wPTLGIif5vthw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-gxuyUGgFGibGUBgdXumqsbQeXAhjntUQIM9H/yvGIQ1TUENLGKj4Y53vkWptVyyl5O0LIgooTcypaBr51fhvjA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-aHgFoZ2aFzxJysM+fdxuciMLIz0vDn4pWbJCX9Pz+wGngxJvIoUiW0lVldHHlNOB4Vj9wTO2te+zvOB25KEYJg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-xwgs0SV+QKBDlgEiJeqMmTxlNSQ5KyLELd2MNtGEDl9MawtSb+KFvyZlVy7f6ROCG1B5NUDXz7FZ+LKPLgSnUA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-dveQwEJgGBL8SJkBvdQZe5+Rb+xo+uBlCuF0WkHAI3hv2/Zmj2X/ceikVw9yNVSdsS+l7ltP+6GfY7dxLgfHTA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-YXk9Ri0JG4pvCi426q8MvF+NTE8CLsLT3pQ9iY50ZLzsWf3dFOwo5wkXqb72NDhyz90zO5R5SMUHfzLNEzm4aw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-I9YqxEgscSjr5sYKphNswT4TxFTk2yG7RnISgNeHgslx26+AgqFYVMZ6Ibqf8j1vAdm3z69M8/YB3MevNVaZfg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-Wdta1pwcF1+xxCVedkklZejw66RzWfM+Hl7aGaQnpr78Lc0K94nmsyBTc+1UzbywvFBbKUF/yjDCDkcUK8SlYA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-rPzdI1/OLNTBY068wEq3mtP5M5mMnLrz4umD4FKqyI+Qk+vcszwoLeWyGAL71F5MteMidz+ac5CGNcPHFkmFPQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-mrrdJRzFud1vKPZBJI+kG/bTDcJCDXSOIw11VB+MVybM0WKdlPAC4/WSw8lbWpnL20nDlPXlzO3SisQiQljUAg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-lcwQOd2lh1Rm+zbXLrSsN8K2/ioa7zLLeBWeKJHcI/vCvRZNoKtdyAgB/LdCVLuvoss2LRKqwI/jN4jzUrt+Ag==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-au23m99OD1b9JlNZrEU/QmyVK72KOEGWPSIoYiVrOpxCZjhP+WRmETR/s+W38/TBmu5svwoc0hdM6s81NOxyZg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-MkTvbmIglNnO97j/IWF4pDueVWPiuV0uwCh8l1DWcZaZqFiJHJWAn7AT1AZ7GdgDbUiwnpkPtB4qiCjBTptkUg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-IaaAKrGJDjeDpeYXy271j6Y2VHuzadeRhV66UYWF8Sc/+DnedKKikp/Zbs0QUaS2rqFfIUSVoQz8QQXHEWey6g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-/BhAL17QE5izditAizw3LJnLBv+OqlMoGmlmYtGv5QSPcymqngnHWtYqX6sOa/uRMedShdfBV3WECee2SV+oVA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-GhZZaiUpHoP7t0rGjhlQzO0QfOZdGVPFm/pIi04pV2XmhWj8r8u0z4ZEABiB+QeI0F95fYqgEJGfG3pg8gJPUg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-hUR8wo9zpFfQf+Z3NQONUvStGrHo31wJqFRwFuLX1EREg3yBzjXYQlEZ6iG8lTAqoEzO4uWQaPoV7fF2na3QZA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-cC1gQAK6ZK6sMtIjt42AINLQ3xRf1d6MzDuD9XtCK5eqcPf2GirBglZfB93DWNd96M2kuKrJPYxTcy1MGnhuRA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-YSHwW+Jm58mM1K4LkvW+F6bjrFMs7vPuzJy5RA2Y7YmSVQmHqU/t46S5pRxpf1ierlf9PuosUbH9d/9FhuQ8bg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-YGR0HzEe5HHEiCxQ1HcdMTrv2okOrR+ghDSp3NTjrJayKf4QwVL4nZPxGcHbyNiEOcT6VgRxDFwO9T7HuzvxuA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-+38O+n+hBJvguY36HB1vb5JKPMVSLJCVOnzMsECDQGjjNHbD3nYQ4MdPEPdnMow4xPA1BhFCYIj7cyusuaCUHg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-u0I1eV3Zp6iNd2Yhp1h6ZcrfKqjqWvMX6QjTagnOOiq7nWDd61Oi8buVq1AL9H4fPK++TnI4OzAtOKcoZ7JGDw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-zpnQ46AGuJPn1JhrB12I/IKB+wX3DJ6kTnebnHHcCOcAM2qZMYd4YvqX6LsTCOgVDI0jkFeq1cbyIJPOQ7Hezw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-JAsf6hU75ApUzFSHZweMY42Ww99EdEYnrXjoGLjaPUZvBnffYlmo0I2eytznYY0b1MJNGLRnojBXUlj3BWeQbA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-aa5l0dbB04tqv5gZG36jL+isSM9xBxUQAPDEK+QQgkiGmI2RqG9pVUrR/otB5qxjm/0tNCvYTHkqLg3rFEFEhQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-Pd0oycXZofFW2JtfDiHox/c29Eo30wVG8AvkK3CnkALoUeia2nnVpdT2HRkmh5pAT4yGYR/yYRZ1aAhtQMCByw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-fS2PEsXyXui20naQgEhEUpKuIxowq6yCHOjRf1pBzTQyxpVFPQZ4lg+jMAATSc9A1MdxYpoHHhn5jdVYvduF+g==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-b2LtE44JYQe7BSAR959PHfmTnWZcUIKsLA5TBqafA7/rzDhL7p3r9zwyaE/S38s/E8d1WtRjRbEvWWZJ0XTd1g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-kDEOu69FI+vSXYqdV2+DA2JQdNZ2slSGNzJdhNTKW0jIRvsf1YEwF/gYnzTz9nsQGyc/OfAjI4rRQeNNrFhbZQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-ZcIM51aTbcx9rBEkXtt+iToDeZKsAoG8UusAvkmXOiHI1QkfIqvtT9IffqVN/7VG4J882COQt8+MQKeLzU2wyw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-gyH5c3dFibB1DwuuBrLYOYvwyRqos+u/1kOX0X8tCkRfLicju93JA0rb1e/o/VWwmp08hjX17bWBjMbmmQuGmg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-ZOcV8kwt0W5yUzAlIuOrhx1lrlYud4ACVDtx4OwqaM5boI7dKMAjzVgdynd/Z+3vV5abFotJIj94OlMsw3MVGA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-ac4xfv7Kf9NGTEP5SH2uBIFNAO1jIOHR8/8ORiZCmTq6UPN9GVuBeBljMIyTiD6Jhcm1jQjKcbPP0WSaIVTzBQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-VheCWZGqZf8D6MEpzEd/7aITjnz/xlVoJ42Tk7ZQxMYo5ff004DFwyV0EdXaB6lpYj0wu7ArGZVqaeLOl/O4+Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-6iEEdXEIhbdiuNAapKllrsJ1v9axOKJHP1GyAEUSOukxaZ7irdaW5PgGCmHKDSEzQtLzaA/c3o0Kwu9HafiCTQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-s1JKoqe9iPH3ZmWjo0s5sRNTr9B9cq3OKJ4VrynD5vCaIwq/G2MW+Ls5H13WS1BSglEiOa7gxielAs/f1gHFoQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-cTeVI2EzjjH84E9aRmx37E6oiER2Cs5TfiA8dMtGIhOiDaHy59qNhLdiPZDqmB4uHfFteb5b1YCEL+/PLDrXuw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-qHmkfgkszvM1KnswykllIu/gZ2XClVyXbEgG9LwvMTNzscF7fsk33G7DVmMmq4zr2aB7ebOIE0QBbYZ9pkOPRA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-7vvVqG713zOxhtN+fMkayPUrbh6pueYPfRxziGcVs4GUY1wS367JoKbvfCHHGAiFDurHxUzVdYvo5WamK+S33Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-t8131Cq/b0pU23MgDeEereVt6DRCG/FAFqKdlfs6Z21luxKAayGi2kqEJC/mp4BivbZaSn0Cc7ddSaMY6mrALA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-pPkv1Za/JhLl+GAm/SCQAnST2mdsBoVtbjlz+ffU41xrq44LOqfT7xgh2vBUT/+6oEokIF88qVGrUAAiMMrTVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-duhiuEyyyTbFsmINi8kxJs+gPIkl39O0INN61a9wzByd4bDv1UrV+0nFVE/s+P9johVO33sRkYr/1bpYxsfCuw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-ZU3vLwDWu3XxdqRDzfW+mwEz9derWGlUBBVXJS96hqQleOfrtSv7iwU/YQPm+ChMBaAEk8wI3vqsLh0o3KKDIg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-9WvTu8/kWPU1EB5pkExMBQamgiWadZC6IExalB5xtHAK+NqLokV+r3tf8dhPvx6JtZ77sS/rTqlAOWmW620ucQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-tEZQztHAjZwDisfiny66QP33kn/brI/eGmU29MnpGTD7EgX3b4gNLzpOOl+PkFZGAq7+u0ZgQ+N51iTB6tIwhQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-KZPHGVTOQErG2zsRvCPgJE0jD0ZlqOL07pTaxWp6UJ0xzu6dp3AktPIE6WWZiPjucQZFINWQqfojHRS1/Q3mYg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-lji1y0jbcqB2ATsBx80cIQP1cRaEgUG3FGsjnQT7B2XHwUU969A4hxOjBAVGOUplJ05AnvP0cjjXJi4Cj1P4Cg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-DITNWyCDW+O2Yyju6qCtTGfn8XFvp98ARpoVODhdeQIxBzePrMICZDDYHvxSmJIg173pBtKw3/CIxKyyeRGpDA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-c/w426svLaDDIHh8LRKiXjyO5gbI/UQZ4eon1gi23lMLKoWSBxnUa5nBiS7lf5kaUOFsF4u4nwZOp+e4TiCRxw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-TNGuOrGpbuvOe8p1PMjFLELV295MnvzLt2wYmuiyd+h6pet6MmKns2s00JxZu7nc56iCig6nbTiZnR9VwkPUtQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-06ZE9HRdYfO2ItnTtrKUGkBNuZjgeEJ6TIKqxZOTEXlztzlOs6DmD6PXnMPza1RS02+hGY2qgBvNKiXuaCX93A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-bhAhE0nVjdTZVmacJ7JKuVnN86L83zEztcWeIrLlaehHyzQAlG4g2tpUisnoykXRWKAO4HhCRqI6TBVn8lZluA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-qQTjzb/ZyzlRySjDBEoLmrTS0elPLns6OPTgFdkTWAyhrHVOnKhUaL88NkTg5agX7Yc5ODMent/YsTHnaBmMWw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-wWAndt6bxPny6JrsyKgl12f7Yzd5hf35JAaOSNeMLTE3vtbmIYuWW0gg7CAdH1P/uBNr78AD6pwAEsRcwTNOtg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-tyho9IFTNgbPDijipz5ZyrNj+ArsCIbVqNqawcRSFLlbDSFLyHvufjgtifgG5QQvatnvJ7IwVFLTZj8MXRC4Kg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-uUzbWe5VtrjTbx/0imz18MAYVWdjB7It54ABw6FZATtOSQhsrZw/yFoII+CEtVFbDXYE8d5vCYczTNMQrhUUXw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-qLjmAu12k8JkVDhgXH304GYvbgXRGFb8HlLDL8FE+khiMXxnmlN+Ri3fBdlmD64NNoY6q/BtAikRQlJM9UDYDw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-3JVwYpcAIbcUr7nfH51QMiWKKvgq5jhngac7NJmLzY4agJaQcJy7QxT0yEaQxJNbn1D4Fjy1tS46FMDfO5hryA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-7qtt2uhEEMNl78raGZLhQqGzNIoQKaL4M6URoH6w7UcP1NPj0CH/FhDEBzmIquUZ5tHejliuJS3cjK25ZgwAiw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-Gke2/vSd6pznUB72HsUUnU2FDoz2qFQu2QdAPP25s5OMG64bW95IwND9E5ajQJkKFIVE39bhLd6hpvpwsQRrtA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-MhguJhaxwiSBmZJ1IlPnlKSmaTAOZYtWdpJ0uh8+K8csIr62UWVySjt3HZ0IX6h0dCJgHqpxdQcrdivDgNt3SA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-qBlrCY+7+NcHa2IYCBMFxJxp58wWIjD0m3i74va0OaH2O6/AhAa9dETX4gtUMhpF4IEsiko4rZNQwLfDocYzKg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-97UhKB1JcpPs5OgVo55QZ8qNXhMfMRGfTcCLPBrN4vyIHOSVPRv/EYTeE6XgvDoiDVF/qdJai32QVVboCfGL/g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-nIioWValWLBdCRGyrwLeuZETLcU6epMVu+Qetwu67lJCcNqI+OkpRmlBIw1gtY/1ZZHFRNztrpXVnNRgBnWzaQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-KCau1sxmsgIi8NUp9Jf2TFnw3fE06WkmDsz5Lhj+TpAD9FbNSIrZvCzmUPpAXbzG6oba19f/H8S8yZKBJOYanA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-B9iYc4iAaaj7gX+jdBUyf+4S/d/KgXtzwMwafQshGQEFfOb/dmTuORyRNeWfEZ0gXLFb6xKGIvjNpqJddlxztw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "11.0.0-rc.3.26522.148";
        hash = "sha512-T5LJsd/cLVJjXw0Y0Tc9lByuFZ4A7IhGhpys3PECZpCSMJ6xofIbYlAZrARLhcB85BIEb1IcGYYd04f/gxAtLg==";
      })
    ];
  };

in
rec {
  release_11_0 = "11.0.0-rc.3";

  aspnetcore_11_0 = buildAspNetCore {
    version = "11.0.0-rc.3.26522.148";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.3.26522.148/aspnetcore-runtime-11.0.0-rc.3.26522.148-linux-arm.tar.gz";
        hash = "sha512-KU1mvIaSviz0eFYzek6B99pYPjNA9IfqBpulV/XBqxf3NcoTMQcunOXnnva2QlqPUHRti5q6cYu0gEVQDiiUKw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.3.26522.148/aspnetcore-runtime-11.0.0-rc.3.26522.148-linux-arm64.tar.gz";
        hash = "sha512-4xZVNlEeaV43FoxlCtAqFWQ5LDAA8BkWiqp8gIE9weFgSxX9fIo9Dpm0i6tNVKjWGB465L2yqJ2dlUirvbvR+w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.3.26522.148/aspnetcore-runtime-11.0.0-rc.3.26522.148-linux-x64.tar.gz";
        hash = "sha512-TJMZ3K2N1bXq5zTa42MxADp4TkJAE5XPXiSxk5SplVSUodexf/TpMh2TzR2WDKjGbPmoSekNHbfDWlC6VPgmDw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.3.26522.148/aspnetcore-runtime-11.0.0-rc.3.26522.148-linux-musl-arm.tar.gz";
        hash = "sha512-C4pa2wm/ah4f+A5y1CPEeA5R5zLZZeSde0b6kGhWxtyvpN9fHGlQPL+bzSA0AsfnJAfap8dbGt1A6Ah4s4UTGQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.3.26522.148/aspnetcore-runtime-11.0.0-rc.3.26522.148-linux-musl-arm64.tar.gz";
        hash = "sha512-GInLGUtUw+ILSz2j5a2fZK2qg5vB7jhJTELvplsdz536O08NAc0G3Daqu5pr6YLjFW7uodn3But986YrUY3TxA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.3.26522.148/aspnetcore-runtime-11.0.0-rc.3.26522.148-linux-musl-x64.tar.gz";
        hash = "sha512-hSD2e85NFFDvYDqQwltzPvpAOT5sGQSMy4LWaa6LalidC3Mjkaw79BlV5L1zTXnXUdc4tCCqVBbug/WXiz3uxg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.3.26522.148/aspnetcore-runtime-11.0.0-rc.3.26522.148-osx-arm64.tar.gz";
        hash = "sha512-qwIZyZWXC1N7D3nREsA6kAxruozh8lYWs4m+dkh83I47EAZbWv9YbWtOuP/hfEnBOtLBDz4atsWLlF8R4sYQEQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.3.26522.148/aspnetcore-runtime-11.0.0-rc.3.26522.148-osx-x64.tar.gz";
        hash = "sha512-kdCv55xDVeJ2NBoQ+/2L/mlTWFw8oMLV3AcGGFjWO4MRvNCbLeOfHdsAMMi7nRcEQq6gEJIA9XTkMRSAngmMQw==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.3.26522.148/aspnetcore-runtime-11.0.0-rc.3.26522.148-win-arm64.tar.gz";
        hash = "sha512-py4nmoz769QHoFPG01gPeSuHLpN6adzbc6iyEyKQ6jla7PqjiXwYbr0fdULgo5J+DLB9ya9fVgrlLlCM0lOBmw==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.3.26522.148/aspnetcore-runtime-11.0.0-rc.3.26522.148-win-x64.tar.gz";
        hash = "sha512-YNSGtSEyNTPycenaooVlRS/Fi/tFGVvZmgbYTIi3Mgj49fUh1aeve/qYaFT5UtxkvrwqnHYDo3z/WM7P86oOfw==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.3.26522.148/aspnetcore-runtime-11.0.0-rc.3.26522.148-win-x86.tar.gz";
        hash = "sha512-We8O1qdf6b9oPQgRugg3DXg5Uh70Wm/g0jHZfCG/M3bmrJ6NL/kJb28BoEuRRmAjLR+thKBJe6XxdWeeGFs+uA==";
      };
    };
  };

  runtime_11_0 = buildNetRuntime {
    version = "11.0.0-rc.3.26522.148";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.3.26522.148/dotnet-runtime-11.0.0-rc.3.26522.148-linux-arm.tar.gz";
        hash = "sha512-Gq1g7iJypfZOjrNENbhF3hmek2jgxczP5cTs1B2puQSfAC6ci/vrLC3Rz00luCRgTAlg/q8/iSi75T35dyIDLw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.3.26522.148/dotnet-runtime-11.0.0-rc.3.26522.148-linux-arm64.tar.gz";
        hash = "sha512-+3A2vkgI4kA5ZKrp9G7tVksJwX8CA2sR4ArHtRAj506Zv45UzDuCTfvFznN6EMRDLN8jODcBENMa6hyYlT1AXA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.3.26522.148/dotnet-runtime-11.0.0-rc.3.26522.148-linux-x64.tar.gz";
        hash = "sha512-OwWSg/aJ1DOKLe4z4bQz8iGPnXVOJbloIf9oKB6l0PNU1PKEu6ANi1lM8sFmUxWTtTjj+DCKNJym6ETudMA+uw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.3.26522.148/dotnet-runtime-11.0.0-rc.3.26522.148-linux-musl-arm.tar.gz";
        hash = "sha512-Buzad8NgmWbc/xyirBYLT1IEt69+NU5r+R4VeVHLGZmCj07bZZmuSfrYE98qF1eaKptIod9JKadNNiTSmVR4QQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.3.26522.148/dotnet-runtime-11.0.0-rc.3.26522.148-linux-musl-arm64.tar.gz";
        hash = "sha512-t+aV40gmBwcCSsHsic5EvkrlAePh5f161z7IjmvmKyerrz8+MVpCXWRGVxvhinVhH6qsLDrQdIvj8CUtaqKm/w==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.3.26522.148/dotnet-runtime-11.0.0-rc.3.26522.148-linux-musl-x64.tar.gz";
        hash = "sha512-F8UcljPSg2B8moI/I3lSiUQ596Yovl2Rt127oEAOOswPxBMdRoHL+1MnRIyPGg1ziIX591y3vcFd47bnWLuprQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.3.26522.148/dotnet-runtime-11.0.0-rc.3.26522.148-osx-arm64.tar.gz";
        hash = "sha512-nWa1WBCQe2b2YHQiMo8k58ipBDZoiT8m+96oTE/UkcCsdWXAWI2lm4CS5abzXNA1Fv65VfIQ504uY4X5fLsacQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.3.26522.148/dotnet-runtime-11.0.0-rc.3.26522.148-osx-x64.tar.gz";
        hash = "sha512-NmBm14o04SFJfh6nlEy+aepu8NeOurvkSuXt8QJTK/yTU0NJtKjJK0vBX/Mo9MUxphI5E+7Xd9pbORyT7caIqg==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.3.26522.148/dotnet-runtime-11.0.0-rc.3.26522.148-win-arm64.tar.gz";
        hash = "sha512-p3AX5q1z2WLcFSCDmIQbyxpbVS+jx+PNikyQnAWVRtNt1RkGyboNs0jREwjHV+ZyArNigvlzumQ5WAa6sLnRUQ==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.3.26522.148/dotnet-runtime-11.0.0-rc.3.26522.148-win-x64.tar.gz";
        hash = "sha512-u2j9C07UoiZZaTua/rvz79nCzjVfj6x2ThmE6wZ+O0LmHSdQkBBa9w+9L1Gkr7w0029NPCbMdk21qBu+9SGmsA==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.3.26522.148/dotnet-runtime-11.0.0-rc.3.26522.148-win-x86.tar.gz";
        hash = "sha512-aR37LBrvkcfxTVbtD9dR3DzX1ZWug8ccc0CBeswtMDSckGCp1sV8HVTNRhZ2yXSNq8FQ3A0B+2t8rrrBGyn/8g==";
      };
    };
  };

  sdk_11_0_1xx = buildNetSdk {
    version = "11.0.100-rc.3.26522.148";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.3.26522.148/dotnet-sdk-11.0.100-rc.3.26522.148-linux-arm.tar.gz";
        hash = "sha512-gE0bM8TZQV7BtQB37+ftuhkR6JZ3ldNE1D92AvXNPkQAuoyxAsY70tmCetJ2BWSdrDvMAV5gVSbYu+/FW61zeg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.3.26522.148/dotnet-sdk-11.0.100-rc.3.26522.148-linux-arm64.tar.gz";
        hash = "sha512-6HiMuhh3kqZL3FST2kwpBmBw85lrDXiZ1PSs4vdvfxASF+iINFIjlKoA4wbxyVBvr3T1zSN5++4xSwCsjzS7Ww==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.3.26522.148/dotnet-sdk-11.0.100-rc.3.26522.148-linux-x64.tar.gz";
        hash = "sha512-d+9gNiLwYyzln8YxhxydDsDHQCOZg3xlnq1bb8fqiY9/ZKJjLs3I0zMOYIMHQWo2v/kKTRAXkhBIlnYWe5uA2g==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.3.26522.148/dotnet-sdk-11.0.100-rc.3.26522.148-linux-musl-arm.tar.gz";
        hash = "sha512-l5ZqDqOYcjTo97c8me4x2gzba8CF1OPbfW4ibzctRi/Fgl0ijrfRlhV7CNv7q8xWhZ/0R8bec3TGmFVfc/j37w==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.3.26522.148/dotnet-sdk-11.0.100-rc.3.26522.148-linux-musl-arm64.tar.gz";
        hash = "sha512-9N9TMuBZQeyhZ608DLeV+i8TNf9tRvO3V7VhZIHnDPqwigtxiQLu9yMrCC9wpUxoRuGgi3FnMw/dms23Z2FXNQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.3.26522.148/dotnet-sdk-11.0.100-rc.3.26522.148-linux-musl-x64.tar.gz";
        hash = "sha512-nb5VcQGr1FoUE5bHApOYRRwzQU7diZQQw4hIxArCaLYT7vlzsBAq+Cw3bse59dicY7Acm8FavFnMOVmA+wxQwg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.3.26522.148/dotnet-sdk-11.0.100-rc.3.26522.148-osx-arm64.tar.gz";
        hash = "sha512-sG4QNAKSh2Lzd+VPiCSbdW/QkSGys9gNlGUoFe9J1fLkeSL+/AVV+VStmxo3uohoCJbga8dGtXkQvlo0LBsnTg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.3.26522.148/dotnet-sdk-11.0.100-rc.3.26522.148-osx-x64.tar.gz";
        hash = "sha512-Z12otEn0c+VNwNEEZTaCoG/33S82iqbM+40fv2DChKGsM1Fx5y+exrTZR2zWWoUXnJYFfqwwDRBwtIAsufG3CQ==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.3.26522.148/dotnet-sdk-11.0.100-rc.3.26522.148-win-arm64.tar.gz";
        hash = "sha512-6yp77jsQ4zuC4GvM63vAePgyaAYQQs2fIJDy8F4DqAoaD6nJyFCNv/oxl5PMJoOFric1h8+23LQZ4sXR9gRUIg==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.3.26522.148/dotnet-sdk-11.0.100-rc.3.26522.148-win-x64.tar.gz";
        hash = "sha512-Z/h12913Bt+K9kdeaQtQy+wPIXu04jitHj2rQ5YZUdqw0V2AVIEKacQFMp0VbRmJlhWc74amYJyBc/jsIMnsoQ==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.3.26522.148/dotnet-sdk-11.0.100-rc.3.26522.148-win-x86.tar.gz";
        hash = "sha512-uessjkj1HiGNmszP/+w1rAEk6gPKrtiDgrdT/3CjMtbdgr8vDjzn3Jnxk9unt5i16YjGLw00YaGmkYE8vj13jw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_11_0;
    aspnetcore = aspnetcore_11_0;
  };

  sdk_11_0 = sdk_11_0_1xx;
}
