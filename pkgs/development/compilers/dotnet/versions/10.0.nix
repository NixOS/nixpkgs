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
      version = "10.0.4";
      hash = "sha512-2fhc/5b4xayq032XzWbfq2OxzA73AJbmXf0ApsGZsN4J2pH1QVmMkGQGosLj6nXRzZyO/+X6fxr/hQAFW4ybig==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "10.0.4";
      hash = "sha512-ciTQO77aj6viF8fWXsahVOAG3g7sNTCLC00iugAP0OGZ4FOkrmnPsugavwpLPzOGYa+tOLVIHUbd4auNMVfs9Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.4";
      hash = "sha512-rkH2/iIBEGJ/UCcnH2uJHGZdoKxRKkPhP3a49MCUQszhYtn7r7Bni8xbZvCjGNs22inrLhz4SdEJilvc8J2zVQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.4";
      hash = "sha512-6KFl1QX3Gfl3YK+xhvJ4xNMh9A1HpXY83oE4OewnNdgbtQA+m6nfb2lAfYtGE2FjP25sFsKUfWGrx8krnxqfVg==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.4";
      hash = "sha512-Vavs3zJHRWJfRHr3CGv2CpH/WEPXgxoOtNYYd77JHZekYKO0Y5rzHnRbHhWUnaTyzBNbJpFfafherTuusIeqdg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.4";
      hash = "sha512-fpfauhFh+H32p8nqqPtHKMlKZh2U6im1UdkNzCAus9FjHXaEnvIANplLEzfONYTa9z1579mlnov8ZiX/CrKWgA==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.4";
        hash = "sha512-021Zx/jxyEtcMkFKFdBv5OYWxTe4y8lj/dtPJqmury7IMhSXJP0c3aFsqq8u9WBRI82fzP+TwtaDDjrl6Dkrfw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.4";
        hash = "sha512-RwISoOuBcL4+1IVSl3hx01xoWYkgT38SnBRqwp+B23o9ZvxzwY9lC9zaoCQ6eDMyBB/dB2BM+Fng0ACn8Wl/KA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.4";
        hash = "sha512-NQ8Tfvl/e1JQ1W3WiedgzhBd2PQsELh+rzmdn9wQsP6mXCTYan1J1/g7QVgkJP6D+Ubg9A4VE4g9+u2F0iKJPg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.4";
        hash = "sha512-sXukaKTI3h4hgPFk6Ym8Jvlyidc8U4v4mxTKi72ULeosqxkbx05JEqUeWGWQcKDjALv+sGl/tzorPR5VJq/Edg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.4";
        hash = "sha512-/BM4hkXK+k/3syu3FoFNQ6olQOnEPu+T3qvVr47tL+x/8yYINXgoDEhG5l/Dx6lu+4glFaKs4C0VFXKCr3vmJg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.4";
        hash = "sha512-QpYgLyrx7gYAvDRL8Qmi6aFgDQs5gj3RIQxeix/ocT64PkIeri1kATFrPvMoav+tgg1diJQ90rUxSdgV7eyGlw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.4";
        hash = "sha512-YXzZmLspfD/jbNzeIUyCA3y/C2DnNCWnEMdoTUAPpoN7K/0pMt74V7LBSm25uGhJ9p/qW2T+iS4IH7ldrtwFhA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.4";
        hash = "sha512-VDKV58+QvXx5uPwsn+3Bz5xLtVYyVMByvB+dryMk7twqcmCdNZFQWs+6G1lrtXRA/iF0HEBC2yieWklls1CW8g==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.4";
        hash = "sha512-e948cdl+Q1Us+zr5px4/4SOBaDNR4tWi3W/mjDbbwi41dGj0ZodBUDtIHxx86UsOfPhbWkHHvAEv8qZ3ooKXhw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.4";
        hash = "sha512-leS2CpTya3Eylp/o+x84ywaQ5ar83NbIQ6Yq3sBZHcQRRMGAOIWJNVs2ng0daLjmNJZVtSgabW1piOu38jgzCQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.4";
        hash = "sha512-se3aPXpSrpxqplY44YlBLPYsFTSpkpKcDeY3pFEu10Qsxo38dH63zEmdhAjhYZnx1TvYUPwmv6/YrkRhk+Ec+w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.4";
        hash = "sha512-XUyGyt/hCGXySH72nLTq+gzknG8anrntHMml8im/QrukXm4SuFxh+OWj9nw0/+yFsyMOB9J9xy0z/jxM2nk8Kg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.4";
        hash = "sha512-xfnVNCumH99YKp19ro6iBHe8lFC5/sUIsgIBFXxWJGro0O7Fcd+KEuGOmXarFN/fpYpHDlLRwVziupgjqDs42Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.4";
        hash = "sha512-fUPdibbZNSUTlNPrjW0/bV/MDyttyFxOObZmS4jvS7Xvgf6FWibEsaYsK289cDc/xlDUG16XosbAKZ4ZuK0SJQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.4";
        hash = "sha512-pwbr8mV9fN0e/VvWpE1y/6ao9o+iJtrYShs2zQk+jzpEREh18DLdgxzxthtnTWbLP97+Y+K/r6e11R/5+TLKNA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.4";
        hash = "sha512-4iyecZ2X6+RT7jJEar/y0PHzhNKZqWqk/KKBAm7tLp8Wqfr1qjTJVnUATQ6a7N5ieyDxpvvcie3D5LtuN9c6iw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.4";
        hash = "sha512-EfYZ5LBe86lPiVwCJg2OvyeoUik7HVpSQBfMlLoZz2HpQ2Zn0rHqssW+n9HEp2Fwk1F/ztVDC3wlyhBu+xGPaA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.4";
        hash = "sha512-Eirn7oEQ/TsJbusvL+M0MuU59tEZ0sAKWjvZGV3UDIjQAL1NYKgTPvBJiWzQ9x975Ni4oAQUq3zJbjaOYIkTwg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.4";
        hash = "sha512-qGuOKWeybPQD9R/W19YGENtuRCsdQq4Wy0Yr7oEn4m511C3x0bULcxZ1exQys+S/ssocDlvkGdEfD+MPBNEfNQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.4";
        hash = "sha512-H9FfyJnlLIAVqKt+6sEs3zYleBlXin6yYhv/+JekYlIMFV+KuMedvxZN2UttqSNzM6pxKeH80tWZ5HYh5XvV/Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.4";
        hash = "sha512-f1pQZwbwG5EBsYbgC7JxFQp+C4/qDHMqp7gSyOg++waj9HKuTM0jN80rhVopNC8bWt0+Y+CfzJM+ZlFT0n/vFg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.4";
        hash = "sha512-XzBlUnt2HZWYS4PPEI3ZJdCQq7Twhrkdx7MTC8Hfi81O/DqdyT/HkOl86uolYgw2jkLuU8LRGbc0x/Fa801PBg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.4";
        hash = "sha512-84ApFOmq76HL9HBdfIpWFxEHckDiDmGuLCUAaf27dqgQVOJlNOK3VMPjOZA9+D8gQfRe/ROylVFFubhFKbPHaQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.4";
        hash = "sha512-uubfxexjTJ3NER6HvDeOAH6mP8lGgHVO/axrIeo3sEA672PL8qQn1vMmxjkQ1GxbxWB55JDdKdgL/Vk8+G1aqA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.4";
        hash = "sha512-Uz/1956bhkecYWOvcoic22bdab2X2aDe/dn2Id1ASyPZ965AtbQb5CEucMaV61yAEot0wiNTsbACjPkbU+mSmw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.4";
        hash = "sha512-gWt7zF5ehMaYq/YeaKee3q0GtFOVonCd7OrlzRojIyOx2rj+pjG2YgovGccfmEE3W3TOGc7waU2Y/mqxwJdeaw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.4";
        hash = "sha512-0FMs6gPR7/pts+z7Iwo0s5Ekdr7H7hJBm9G1Q+ELuyqgKJnOObLl+YL/sjJ0sqNqZnIj9O7rQ8sp6yjVW+VkDA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.4";
        hash = "sha512-/uJ4aZ+Uwcy6jta4vdfF9MyexBvSdQd72sw5/ZlysLCAy5X3Vw6dlXmjzbacKo1n9iN8NElm3+AYLx3bZvtSTQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.4";
        hash = "sha512-FGH0Xz3KYff9u/uRN18dx8XuwrBcRAFk3ObYDytekvGO7/bkJKx/kDtvcqPHEhxNMC9jhAybX2iRP0eXzTTHAg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.4";
        hash = "sha512-yz4X6AgI4Zm+JBMotyD0gWtw44qM6ezRT5K6IY14LkG7M6ysFfJIoMyVvlb0udnD5VJGGzcWNNoRlalLdob68A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.4";
        hash = "sha512-kHczUwpQnIgiLebnSB4G/vv9p2i2jMyfNqlC9Nl6kYfvPofpBkHjKpDWR6sIig5Rh+LdD8SiM0wNuIO5t2NjdQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.4";
        hash = "sha512-96J1z3mq5q0dD6mf4PHXWdgVo5bOlXGoNUNYQuuyHqBELmef3BEF39acwMfYgWOIUgIpQvJK8GQ+R5ePX64tIA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.4";
        hash = "sha512-PhW9WNJzJCKmN4qnlKcJDbuq5qiqa3Vbz2debkPqC7BkFLIoywhMQh28jWc4fri2a8LFrOwEvumYUMZo5tbTkQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.4";
        hash = "sha512-f+OgUv21omd2HAEW0qBF3n1aLvGGOnWXdf3/iKQI6fR/SXpsSBoADz5CYaYhYBO0HOJPM5E3HWAHQ5qTY8u8iw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.4";
        hash = "sha512-9W3KohRonW4Wu+lFbpVZXRK7Y7VmSL9b83kGqBuTix2oB+mwxRnrNtUEPFSPtKTNZhMdLcfSET0FaX2PH+7GOA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.4";
        hash = "sha512-ILbFXb6rfYCjI/j2EEPTzIYTCXnpok+wL5DZXEYllHj6ruXBLaSIdrNX7eOZmkO1Wpwy2Xwy2kjN3vYatZvflQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.4";
        hash = "sha512-AL7zburEEE9hP8SrR1a3zs329I6YcjJlsucmkDqCaVcHHr+B2xcJHi3SjQfzPbCs38hSMzM/zjzpkS2aJ62Rag==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.4";
        hash = "sha512-Zv0+bhXIhKzGvA23SC9ZWqm/d9HdXpZtkc72sZSCkShmP25h3sWqW3Z1b1S6WCfmAfsxAT0tCYogWkCtPzKIrQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.4";
        hash = "sha512-WCeQtTdpK+pPrUXlp1trs9kc9SWgSO7+ojb7Twm5RX2xdEvqCoNiz37hItjRvBshYExinnaYVNTP7/7xeKDYxw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.4";
        hash = "sha512-S33T3FnUdqu4q5XN4ZDo3OwKYn5F7R6Pq065fJp8tromAZX35TcX8+nzlY1quFqLYbAc7sT8v9zVxI/XDgEFWA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.4";
        hash = "sha512-JsmY62u/ZzAycsBLeKvzovP7O8lLDQBhEdDVpJrfEiZwwOi4O9RZwC3G7CS3HVcn0Ms8TQWUP4BkKupZAHZ67Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.4";
        hash = "sha512-/QJrBzdIcHFhLdgpMS+pClLd91t1xg84ymQSC5fcvUzTyu5vZae8Cp4i6oAntTqPqz0coh6Hmw27jAVd20g5qg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.4";
        hash = "sha512-O7eOw6/xllP+iZCl+oTrAyxTWRckJGZNaeS+PSDXAM4Mvurivg/Wf818nlC086ZXcyNvQYacXKYtYfnJjulbJw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.4";
        hash = "sha512-JXLYSzXCMbkT+qmobcd9s1ngK16Audw1I/iaGVQ8OTvYhr1iMdeZmoI7P8xuHwduB8VSKo2POsAdjfG76yaeFA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.4";
        hash = "sha512-979LysjZIdaDR+6WyM7YcdeWh96NPWrw3xLDQKXei9VkoFrX5DNqHHMNOarWMqrq+wCRtOjJMva5ifOP8wQWtw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.4";
        hash = "sha512-MtXZ87brqKMtJl/fYzyQ58ZoIMnetNonguyo28ihdjzVi14fFjgvh8ZbncLi8o/CPihmt3WTbuNTxvoMyh2wtQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.4";
        hash = "sha512-iY340FCG8zJrNUqqKknLmx69sS2lkPffk1/v3Wp4yVG7Ong7VM4Lu2JE+fS1coZx3O1Sg9JiGT+YwWaUvsUihA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.4";
        hash = "sha512-aGkCKfnMJwnXHtyfu6UI9b9K9q2pCC24YKCBEHCdxca+0a+Ohfhy4voU/tgj/cwN9rMGiI1BaK7KkWDeM1zhfA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.4";
        hash = "sha512-jr/+unD1pP8sG/q9GYgS+ZLYkEk19lvUol6p0MHbRPLB71AoijSAXslWSM5t6+OAS7inj1+NrypvRoeZBk7H3w==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.4";
        hash = "sha512-fXfrjmfwk83Hjrrge6ztScuMXUgXFPUOr7AzUKYgQ+ulf9glBOX+N+58kbdZQ/btd4Mop3euPSqFVKekZvtSlQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.4";
        hash = "sha512-6DIYjSoRby4qqX4Ehe2tMzmxf58V75ZTXIrDTKmNWjnptH4dKl5b6W55/YoJ8380ewBJ88lRK2FG4mVFPhOBuQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.4";
        hash = "sha512-r6dTTlV8rI7TuPQXEOvLzZX1BPJ1tVE51W/gsyDSbIyXiXwJ2VRBRU4fqxLcEqZk9v1KMGMxMK90YIapyuXdDQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.4";
        hash = "sha512-aRs+psYKqWAgTbOxX+n7LoHcPQqSeLpdQisTS7fc0YUTxOVOQ8NI/pn+dq/NZJ+WMO4Rq8w9tr07xYENR5CfGg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.4";
        hash = "sha512-3vUYgrfzXNsaWxlmW9e3jlqjLCYVqZ1LHgigd5NCvvF9fj3tCx3+xIOyN5Ljucr9d8cozXyvc7tkfmtSM96IyQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.4";
        hash = "sha512-hyQSXptLzo6wFe5u5LHxnhwSCe2YpXPscisAyt1p3AhD9f0wYgjYULDqday9BwuaOXYTeQUoq6xVjKgeVITjgA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.4";
        hash = "sha512-VAlbp5nGER//6vEpUwhAcnPG+e8yQdS4SUU0kj8YGzkQda3Im85qiudNyk89ZebxGtZRtPF/ltyUyYmQLBGyGg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.4";
        hash = "sha512-Se65vFFlveYdpdDGrR0udtzgMC+gx/D2ZohIXY+PupnuOgUMsiHU2twJBI4pH30wJnVn6JLEZ1L//Zjsh8h7Dw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.4";
        hash = "sha512-AwwHGtS3ntC5G1l7KBI+Y1ywaRhE0h6vJ4TY8eAU/K9W5syzn1+RQ94Z0BNiFVssZ8XubCd59kjmUAyhFfCoRA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.4";
        hash = "sha512-lOmryab3u9QWXnJwNVtu9Sp4L6wqqqB8UZXFFePopDzhRpOiZlM8/Mw3fhEoc20j0OgaEU6A2Jli/07Q2t9kGw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.4";
        hash = "sha512-3W1cyqaBu5rTJdVz7Uoa5RIKorPzzqeARcgMQgF24dGMie9Oz/6KjihH9x8bJcDduEr370xSzeA8FBGmq/Aw5A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.4";
        hash = "sha512-h/SVDcM6pA5e53DmTZLNPIh0DbyYM5gxI11sjl39ew+PxhOE36L8H5788MzQ3b3mrIxAxN9O8Y3eOkLudr9XGQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.4";
        hash = "sha512-hvVJ6aMlWBheA5BAPsz9WFhwo3sbV1B7v3pyoX1wlPuRQ+p1Fb4nXZu5NHfYtT1B1bi47cC8Z/Er5EYVXMZIFA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.4";
        hash = "sha512-rxa/o723+p49GswaVfgCSRgw+C3V0Xv7CxL9TcSIVUHnFkZ5Hydjo68YCC/65817lbB7quI9HEWfrr8HIIfBEQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.4";
        hash = "sha512-3YvNQUsX8zP32mjjs6VtuzL9vdD+Eo6NG2yjEzCh+yPUdLR8WeMB1/Gob6Ft0LpSrCLFEsNungK/uwpYSkUwLg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.4";
        hash = "sha512-o3shJMNtzvXg2c8Qc7ZfDRHmRWMFVyD89pejkKBG4fxGDG8Qh08FeeP/3tFJXdVX16N2ZomlaEal1Swms1XOww==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.4";
        hash = "sha512-Zg/9YxQGcDn4BEB28kqw87eAhxeOk+OWWf6FlTN1nCpRb0T6wjvuj/+VaOF6rr31FP6WHefrOkJe230iqTMXvg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.4";
        hash = "sha512-fdLEHsCQOL1hDHFXTAW2Z9dqxPKdThxXHLLmuIm9VeRVJUm/0DJa5tpyBspZqgrYYHjEsYzMlGTBYmQ+ILdILA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.4";
        hash = "sha512-weBcLOXBVUiEfCBOHv0lEPRxwNjfIrMnGU4bvybZN+KCjy2MpxXGr9C86wjch/nWaHCU+2najSsUlMl6BPV9vw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.4";
        hash = "sha512-J4yUvH1VtwFSq2ro01iHFeNgkc2ql/JAx54IZJYHoIHJZm9d2Bu5d3H+oLo6If3+0iAK+bO8Gw4I9++5qLnF5g==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.4";
        hash = "sha512-dFCi2B0jGbJOhtUdsP9lMG8Y9j6KB8HEBotc3+OaXD77ZQxBMOPppI0WL5av148iIO5j3pqJPUa1IKQBNtM6Wg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.4";
        hash = "sha512-72W5R//wUzhtFbsFUNrsuu+6tGf83KCg5jZt2zG6Zf5QuVRxdLNsMMCF4Id4aufnb8V3i09FHdUC3QMLphPMBQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.4";
        hash = "sha512-msy1x7wT1WvJWyWvVHxeyAl8VH068iw4BneMPCTYpXpDElrM18j9XCRordDi9GBpXc7ty6NH9Y27I+8ypwLFlg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.4";
        hash = "sha512-Fy8I6PaAUWWnCN1K4Cj/eOXPcKvCY6kZK6nYQbz9o4CCkK3fY3fOQluV3EgW4qN6PBYedfxaCjcpBYQewlJ3yA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.4";
        hash = "sha512-eNb1SvgRez2mLyBUr1/T/s8wYA21P0lSFFX0uzKKF4/W0fPH/qejEn0nWFFg8BEbt4GeNRGMeo3x40wdnGFsag==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.4";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.4";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.4/aspnetcore-runtime-10.0.4-linux-arm.tar.gz";
        hash = "sha512-Iomw8xW8bZ54ZE01hIzmRq3d01P7d/xM7/OH9okGyvZ5QfduW9Rvbu7ddhB2KfV8/jXJjxUFo7TWdzpqTIJusQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.4/aspnetcore-runtime-10.0.4-linux-arm64.tar.gz";
        hash = "sha512-oLPAKeSL0mm2VtiJN2Lo8cSnmepRpW+KOOStRWwJYbA6LN3uMEos7LcF5WvJxU82gx1FJqII2wsZDroibYiWdA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.4/aspnetcore-runtime-10.0.4-linux-x64.tar.gz";
        hash = "sha512-SvZrYKsglKafeI3/tvg4+Xv1eGnLn4eY2tFm+dMDqx6I+z9KSI6l+/8DaiTbTFo/Gd/zZI0C8P3kbChcu8kSyg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.4/aspnetcore-runtime-10.0.4-linux-musl-arm.tar.gz";
        hash = "sha512-AspfU3ozPg9O/REQ5l58C524k7Le6eaRHgj/9vO4QNaU0eyhFojpy0snlCdiROWnb2Eigl3avA50ntmEXn5WjQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.4/aspnetcore-runtime-10.0.4-linux-musl-arm64.tar.gz";
        hash = "sha512-Y96HZIBSr3cciv3XJSPDlr/P2SS60lz0Cpx46zvK3YTsK4QmvVUyKIu0Nke6eGVwVF+mp/e+o1BCRJKibWxYJw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.4/aspnetcore-runtime-10.0.4-linux-musl-x64.tar.gz";
        hash = "sha512-XYr/N9MaIOf/qhVgjctomJjeFgSnMaOYiSteffnOECM2Aq8Qk59w5Zkcb4lpunrbsl9THuRDl11WRTMdx/dLEQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.4/aspnetcore-runtime-10.0.4-osx-arm64.tar.gz";
        hash = "sha512-jA6x4Anfx9C05ZDRl9MBgbz7Z750RLqGFxQmpIuHASnM5SyIdjOzRB97p11CAQfPj70CDmvnGhchPiqxDFro7w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.4/aspnetcore-runtime-10.0.4-osx-x64.tar.gz";
        hash = "sha512-e0bXDdnVIJlzfXViLfk55pKy747nuoW14rQFgHLrKSmqjQI8yH1eM7uGlytg2vg4VLXpu/yazUeV4MIbat+YDA==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.4";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.4/dotnet-runtime-10.0.4-linux-arm.tar.gz";
        hash = "sha512-PMegd+XV+qUFcXQfPR95sNnezowAWIetXhle/p5EeRFk17U7WGLON0WfILv2z4rG7OyeecxVamvic4syA3oLaA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.4/dotnet-runtime-10.0.4-linux-arm64.tar.gz";
        hash = "sha512-SXt9Z3R7IYvDghuaeRUn9pZiJhGlO3Vb8vK5X1O64U4eXYzdbCJUPz8tdvXRizrCMDvCI1HI63AIqUGn/TLZdg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.4/dotnet-runtime-10.0.4-linux-x64.tar.gz";
        hash = "sha512-LicwykZYOPNlXI0FdqJHdTGpx2QynZ48iMjIuHsnCPmBgZ6Tne+L7CBLkOmGVLOg9uR7gW9E66uVswxQKAYNbA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.4/dotnet-runtime-10.0.4-linux-musl-arm.tar.gz";
        hash = "sha512-16eKg/VgxVI84+DBUMsZo8wZ29uN4pivVb63H/Wt+1spCyP/GJL6JTUVr/ewB/4PtYQ/WCDCJBr+88wMvHKmMg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.4/dotnet-runtime-10.0.4-linux-musl-arm64.tar.gz";
        hash = "sha512-h14xqJlpAgB2nmw6ub/MHKIvphlFuYFar0HpqtVtokbe35RxLK8a9MwXGdCNXKHiijhg+xty4v2IRfm7DL3hzg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.4/dotnet-runtime-10.0.4-linux-musl-x64.tar.gz";
        hash = "sha512-kUu/zGRT/n1uholqQl4W2hj46DAAYR5YAp1UKNXAQT+flCydTDRU+KEdd8X3rtKA5KMbb8M9z0F/imHDOI9FVg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.4/dotnet-runtime-10.0.4-osx-arm64.tar.gz";
        hash = "sha512-PF/yGusLAO2IgeTf+PldSIgy0hN+QGuPGb20qQRPf8iswqu8I+V+0kEB184PNCbD7LlT9oEo2GqNk5mPut8y9w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.4/dotnet-runtime-10.0.4-osx-x64.tar.gz";
        hash = "sha512-4K/1Z6lUSWEHEBGUS2q0pRdcCDbWVM0jb4LKv8DE8emHnRHRceqO0LLrp8m1iPjO8VzHNiBPLKXKMnRGeUaduA==";
      };
    };
  };

  sdk_10_0_2xx = buildNetSdk {
    version = "10.0.200";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.200/dotnet-sdk-10.0.200-linux-arm.tar.gz";
        hash = "sha512-2M5YxJCm2Wg796OxJqZ2AdFPpbvesE+CKfW3YEYc9ldLlTEWZBM3HY2ZUZ0UfrRquZ8mjl6Er1fouWxcrfjzRw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.200/dotnet-sdk-10.0.200-linux-arm64.tar.gz";
        hash = "sha512-7QAQQnHE2zBj0HOe/kjuI5XV0415Ut5THdTuEXffx2J1HvCuXoVucfn2s6dbntnTjGkjQPUKrPJA3RHCArRuNg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.200/dotnet-sdk-10.0.200-linux-x64.tar.gz";
        hash = "sha512-SHOP7ZHWpH2vd4tXKf4WnWWhukPV7MPk2hOXErZtLGLFFoeHAPXidJ9K+PgWyjVi89kzZ7A+Nptvr/r8Ebzmmw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.200/dotnet-sdk-10.0.200-linux-musl-arm.tar.gz";
        hash = "sha512-9JnWH5RV2argZbE3zU9aZZJrofFmt1C4SW8kjFxBtWLANvNgoJfg7Pqwt0QeQJNGFEnJqIOzs+ZwF7pj/tNHVA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.200/dotnet-sdk-10.0.200-linux-musl-arm64.tar.gz";
        hash = "sha512-px0bS+pbZpNWumGz4AhI6U9LH1jO6pDVdF1hZh/PW3H6sTzy+1TptSO5sPyB2u34dx9zWrgkqvex6e1hYg0l5w==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.200/dotnet-sdk-10.0.200-linux-musl-x64.tar.gz";
        hash = "sha512-ComhYrOk/XO4M9O1a3cTD/1Gu2u+1mASNLhf0OXI8VlZweonW+Fqvkdajn74IIq/FXIHHsSvAlcSglIbRTHEzQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.200/dotnet-sdk-10.0.200-osx-arm64.tar.gz";
        hash = "sha512-n40RBsW9XPf2QhN8/SwYDdm7O3bCfDjr9Pcq9wxswsy9fpJ0GGCys/IOmDIUVz1Jq++Hz79SQD2oZS2Z0uIcVg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.200/dotnet-sdk-10.0.200-osx-x64.tar.gz";
        hash = "sha512-eS5xE6R4IKQjvLMAsO1C3tBQJB9JzE0b52Q8Gh13yXLeSWxZpcfQMS9d+nxwGL+EquqEcE7VCsu66awFL16aXw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.104";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.104/dotnet-sdk-10.0.104-linux-arm.tar.gz";
        hash = "sha512-FjvNGWHoQY2D6CrvULBg1L3qjuVyRB5xECJbYepY82UX4FXuvSPr0cxH3KrkRinAGnEr513fvkJv56xgcMOKdA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.104/dotnet-sdk-10.0.104-linux-arm64.tar.gz";
        hash = "sha512-PCQ+JhZpoOaekHSwq7voEllvjgUbrz5YhDaVnwvXA3Jg1SJXtr6a4xUazNqROU1NHgcl9pJyZIz0N5fCy7GMWQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.104/dotnet-sdk-10.0.104-linux-x64.tar.gz";
        hash = "sha512-3EdehcbVw0wnwldyo8k6lO7Am8zLhAm2ENP64BapBDzrmf9g86ADRDxumSV+I3v58MtcUJBJ7HB+kkmHdtHjXw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.104/dotnet-sdk-10.0.104-linux-musl-arm.tar.gz";
        hash = "sha512-X8JWPQIiN+ijnvQwh4neESgArNHJLGZkk0Lerr3+1arYh43M0t6t/LldUNY/7KpnHjBSsyKtdEetmBfRElWkhw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.104/dotnet-sdk-10.0.104-linux-musl-arm64.tar.gz";
        hash = "sha512-UcXTZzyNuyvhVjo4arMP6d6l2bhLzIrF3tvpceVkCRrgatH/o03PSmmV0UOk6miw2MJB10kTsC9W/q6vhsZCJQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.104/dotnet-sdk-10.0.104-linux-musl-x64.tar.gz";
        hash = "sha512-X1v67/GRlAaw72jL9a9lzhwwtP+/yMEkBNtWquIazovZ9qjjEAMhxtn33UvENj2UFUtkWGNTeo8A8iVIw6ya0Q==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.104/dotnet-sdk-10.0.104-osx-arm64.tar.gz";
        hash = "sha512-USYFjeCagP5zVBM3KFb8cXFdJNcROTzHkq7mlfxKZlxjBydf6W+YNNBsZcz1aggYx8U7vLhIOdPjJBF/fSw8Zw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.104/dotnet-sdk-10.0.104-osx-x64.tar.gz";
        hash = "sha512-ADTWst2g8YqlUh8iVN/xf8rJwm+zuUL8ZQlsfd4WymnLMWxPXB6a17dL0+qfKfPomCHxPS1QPAbtuAy02VwT3w==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0 = sdk_10_0_2xx;
}
